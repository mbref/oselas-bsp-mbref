/*
 * mbref-uio.c
 * Copyright (c) 2011-2012 Li-Pro.Net, Stephan Linz
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/spinlock.h>
#include <linux/bitops.h>
#include <linux/interrupt.h>
#include <linux/stringify.h>
#include <linux/pm_runtime.h>
#include <linux/slab.h>
#include <linux/of_platform.h>
#include <linux/of_address.h>
#include <linux/of_irq.h>
#include <linux/platform_device.h>
#include <linux/uio_driver.h>

#define DRIVER_NAME "mbref-uio"
#define DRIVER_VERS "0.0.3"

struct mbref_uio_platdata {
	struct uio_info *uioinfo;
	spinlock_t lock;
	unsigned long flags;
	struct platform_device *pdev;
};

static int mbref_uio_open(struct uio_info *info, struct inode *inode)
{
	struct mbref_uio_platdata *priv = info->priv;

	/* Wait until the Runtime PM code has woken up the device */
	pm_runtime_get_sync(&priv->pdev->dev);
	return 0;
}

static int mbref_uio_release(struct uio_info *info, struct inode *inode)
{
	struct mbref_uio_platdata *priv = info->priv;

	/* Tell the Runtime PM code that the device has become idle */
	pm_runtime_put_sync(&priv->pdev->dev);
	return 0;
}

static irqreturn_t mbref_uio_handler(int irq, struct uio_info *dev_info)
{
	struct mbref_uio_platdata *priv = dev_info->priv;

	/* Just disable the interrupt in the interrupt controller, and
	 * remember the state so we can allow user space to enable it later.
	 */

	if (!test_and_set_bit(0, &priv->flags))
		disable_irq_nosync(irq);

	return IRQ_HANDLED;
}

static int mbref_uio_irqcontrol(struct uio_info *dev_info, s32 irq_on)
{
	struct mbref_uio_platdata *priv = dev_info->priv;
	unsigned long flags;

	/* Allow user space to enable and disable the interrupt
	 * in the interrupt controller, but keep track of the
	 * state to prevent per-irq depth damage.
	 *
	 * Serialize this operation to support multiple tasks.
	 */

	spin_lock_irqsave(&priv->lock, flags);
	if (irq_on) {
		if (test_and_clear_bit(0, &priv->flags))
			enable_irq(dev_info->irq);
	} else {
		if (!test_and_set_bit(0, &priv->flags))
			disable_irq(dev_info->irq);
	}
	spin_unlock_irqrestore(&priv->lock, flags);

	return 0;
}

static int __devinit mbref_uio_probe(struct platform_device *pdev)
{
	struct uio_info *uioinfo = pdev->dev.platform_data;
	struct uio_mem *uiomem;
	struct mbref_uio_platdata *priv;
	int i, ret = -EINVAL;

	if (!uioinfo) {
		int irq;

		/* alloc uioinfo for one device */
		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
		if (!uioinfo) {
			ret = -ENOMEM;
			dev_err(&pdev->dev, "unable to kmalloc uioinfo\n");
			goto err;
		}

		uioinfo->name = DRIVER_NAME; /* or: pdev->dev.of_node->name */
		uioinfo->version = DRIVER_VERS;

		/* Multiple IRQs are not supported */
		irq = platform_get_irq(pdev, 0);
		if (irq == -ENXIO)
			uioinfo->irq = UIO_IRQ_NONE;
		else
			uioinfo->irq = irq;
	}

	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
		dev_err(&pdev->dev, "missing platform_data\n");
		goto err_cleanup0;
	}

	if (uioinfo->handler || uioinfo->irqcontrol ||
	    uioinfo->irq_flags & IRQF_SHARED) {
		dev_err(&pdev->dev, "interrupt configuration error\n");
		goto err_cleanup0;
	}

	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
	if (!priv) {
		ret = -ENOMEM;
		dev_err(&pdev->dev, "unable to kmalloc\n");
		goto err_cleanup0;
	}

	priv->uioinfo = uioinfo;
	spin_lock_init(&priv->lock);
	priv->flags = 0; /* interrupt is enabled to begin with */
	priv->pdev = pdev;

	uiomem = &uioinfo->mem[0];

	for (i = 0; i < pdev->num_resources; ++i) {
		struct resource *r = &pdev->resource[i];

		if (r->flags != IORESOURCE_MEM)
			continue;

		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
			dev_warn(&pdev->dev, "device has more than "
					__stringify(MAX_UIO_MAPS)
					" I/O memory resources.\n");
			break;
		}

		dev_info(&pdev->dev, "0x%08X-0x%08X\n", r->start, r->end);
		uiomem->memtype = UIO_MEM_PHYS;
		uiomem->addr = r->start;
		uiomem->size = resource_size(r);
		++uiomem;
	}

	while (uiomem < &uioinfo->mem[MAX_UIO_MAPS]) {
		uiomem->size = 0;
		++uiomem;
	}

	if (uioinfo->irq != UIO_IRQ_NONE)
		dev_info(&pdev->dev, "IRQ%li\n", uioinfo->irq);
	else
		dev_info(&pdev->dev, "no IRQ\n");

	/* This driver requires no hardware specific kernel code to handle
	 * interrupts. Instead, the interrupt handler simply disables the
	 * interrupt in the interrupt controller. User space is responsible
	 * for performing hardware specific acknowledge and re-enabling of
	 * the interrupt in the interrupt controller.
	 *
	 * Interrupt sharing is not supported.
	 */

	uioinfo->handler = mbref_uio_handler;
	uioinfo->irqcontrol = mbref_uio_irqcontrol;
	uioinfo->open = mbref_uio_open;
	uioinfo->release = mbref_uio_release;
	uioinfo->priv = priv;

	/* Enable Runtime PM for this device:
	 * The device starts in suspended state to allow the hardware to be
	 * turned off by default. The Runtime PM bus code should power on the
	 * hardware and enable clocks at open().
	 */
	pm_runtime_enable(&pdev->dev);

	ret = uio_register_device(&pdev->dev, priv->uioinfo);
	if (ret) {
		dev_err(&pdev->dev, "unable to register uio device\n");
		goto err_cleanup1;
	}

	platform_set_drvdata(pdev, priv);
	dev_info(&pdev->dev, "registered\n");
	return 0;

err_cleanup1:
	kfree(priv);
	pm_runtime_disable(&pdev->dev);

err_cleanup0:
	/* kfree uioinfo for OF */
	if (pdev->dev.of_node)
		kfree(uioinfo);

err:
	return ret;
}

static int __devexit mbref_uio_remove(struct platform_device *pdev)
{
	struct mbref_uio_platdata *priv = platform_get_drvdata(pdev);

	uio_unregister_device(priv->uioinfo);
	pm_runtime_disable(&pdev->dev);

	priv->uioinfo->handler = NULL;
	priv->uioinfo->irqcontrol = NULL;

	/* kfree uioinfo for OF */
	if (pdev->dev.of_node)
		kfree(priv->uioinfo);

	kfree(priv);
	return 0;
}

static int mbref_uio_runtime_nop(struct device *dev)
{
	/* Runtime PM callback shared between ->runtime_suspend()
	 * and ->runtime_resume(). Simply returns success.
	 *
	 * In this driver pm_runtime_get_sync() and pm_runtime_put_sync()
	 * are used at open() and release() time. This allows the
	 * Runtime PM code to turn off power to the device while the
	 * device is unused, ie before open() and after release().
	 *
	 * This Runtime PM callback does not need to save or restore
	 * any registers since user space is responsbile for hardware
	 * register reinitialization after open().
	 */
	return 0;
}

static const struct dev_pm_ops mbref_uio_dev_pm_ops = {
	.runtime_suspend = mbref_uio_runtime_nop,
	.runtime_resume = mbref_uio_runtime_nop,
};

#ifdef CONFIG_OF
/* Match table for of_platform binding */
static const struct of_device_id mbref_uio_of_match[] __devinitdata = {
	{ .compatible = "xlnx,plbv46-mbref-reg-1.00.a", },
	{ .compatible = "xlnx,plbv46-mbref-mio-1.00.a", },
	{ /* end of list */ },
};
MODULE_DEVICE_TABLE(of, mbref_uio_of_match);
#else
# define mbref_uio_of_match NULL
#endif

static struct platform_driver mbref_uio_driver = {
	.probe		= mbref_uio_probe,
	.remove		= __devexit_p(mbref_uio_remove),
	.driver		= {
		.name		= DRIVER_NAME,
		.owner		= THIS_MODULE,
		.pm = &mbref_uio_dev_pm_ops,
		.of_match_table	= mbref_uio_of_match,
	},
};

module_platform_driver(mbref_uio_driver);

MODULE_AUTHOR("Stephan Linz <linz@li-pro.net>");
MODULE_DESCRIPTION("MicroBlaze References simple UIO lowlevel driver.");
MODULE_LICENSE("GPL v2");
MODULE_ALIAS("platform:" DRIVER_NAME); /* work with hotplug and coldplug */
