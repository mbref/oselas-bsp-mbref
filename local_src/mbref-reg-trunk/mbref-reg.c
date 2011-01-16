/*
 * mbref-reg.c
 * Copyright (c) 2011 Li-Pro.Net, Stephan Linz
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
#include <linux/platform_device.h>
#include <linux/uio_driver.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>

struct mbref_reg_platdata {
	struct uio_info *uioinfo;
	spinlock_t lock;
	unsigned long flags;
};

#define DRIVER_NAME "mbref-reg"
#define DRIVER_VERS "0.0.1"

static irqreturn_t mbref_reg_handler(int irq, struct uio_info *dev_info)
{
	struct mbref_reg_platdata *priv = dev_info->priv;

	/* Just disable the interrupt in the interrupt controller, and
	 * remember the state so we can allow user space to enable it later.
	 */

	if (!test_and_set_bit(0, &priv->flags))
		disable_irq_nosync(irq);

	return IRQ_HANDLED;
}

static int mbref_reg_irqcontrol(struct uio_info *dev_info, s32 irq_on)
{
	struct mbref_reg_platdata *priv = dev_info->priv;
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

int __mbref_reg_pdrv_probe(struct device *dev, struct uio_info *uioinfo,
		struct resource *resources, unsigned int num_resources)
{
	struct mbref_reg_platdata *priv;
	struct uio_mem *uiomem;
	unsigned int i;
	int ret;

	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
	if (!priv) {
		ret = -ENOMEM;
		dev_err(dev, "unable to kmalloc priv\n");
		goto bad0;
	}

	priv->uioinfo = uioinfo;
	spin_lock_init(&priv->lock);
	priv->flags = 0; /* interrupt is enabled to begin with */

	uiomem = &uioinfo->mem[0];

	for (i = 0; i < num_resources; ++i) {
		struct resource *r = resources + i;

		if (r->flags != IORESOURCE_MEM)
			continue;

		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
			dev_warn(dev, "device has more than "
					__stringify(MAX_UIO_MAPS)
					" I/O memory resources.\n");
			break;
		}

		uiomem->memtype = UIO_MEM_PHYS;
		uiomem->addr = r->start;
		uiomem->size = r->end - r->start + 1;
		++uiomem;
	}

	while (uiomem < &uioinfo->mem[MAX_UIO_MAPS]) {
		uiomem->size = 0;
		++uiomem;
	}

	/* This driver requires no hardware specific kernel code to handle
	 * interrupts. Instead, the interrupt handler simply disables the
	 * interrupt in the interrupt controller. User space is responsible
	 * for performing hardware specific acknowledge and re-enabling of
	 * the interrupt in the interrupt controller.
	 *
	 * Interrupt sharing is not supported.
	 */

	uioinfo->irq_flags |= IRQF_DISABLED;
	uioinfo->handler = mbref_reg_handler;
	uioinfo->irqcontrol = mbref_reg_irqcontrol;
	uioinfo->priv = priv;

	ret = uio_register_device(dev, priv->uioinfo);
	if (ret) {
		dev_err(dev, "unable to register uio device\n");
		goto bad1;
	}

	dev_set_drvdata(dev, priv);
	return 0;
 bad1:
	kfree(priv);
 bad0:
	return ret;
}

static int __devinit mbref_reg_of_probe(struct of_device *op,
		const struct of_device_id *match)
{
	struct uio_info *uioinfo;
	struct resource resources[MAX_UIO_MAPS];
	int i, ret;

	uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
	if (!uioinfo) {
		pr_err("%s: %s: unable to kmalloc uioinfo\n",
				DRIVER_NAME, op->node->full_name);
		return -ENOMEM;
	}

	uioinfo->name = DRIVER_NAME; /* alternetive: op->node->name */
	uioinfo->version = DRIVER_VERS;
	uioinfo->irq = irq_of_parse_and_map(op->node, 0);
	if (!uioinfo->irq)
		uioinfo->irq = UIO_IRQ_NONE;
	else
		pr_info("%s: %s: IRQ%li\n", uioinfo->name,
				op->node->full_name, uioinfo->irq);

	for (i = 0; i < MAX_UIO_MAPS; ++i)
		if (of_address_to_resource(op->node, i, &resources[i]))
			break;
		else
			pr_info("%s: %s: 0x%08X-0x%08X\n",
					uioinfo->name, op->node->full_name,
					resources[i].start, resources[i].end);

	ret = __mbref_reg_pdrv_probe(&op->dev, uioinfo, resources, i);
	if (ret)
		goto err_cleanup;

	pr_info("%s: %s: registered\n", uioinfo->name, op->node->full_name);
	return 0;

err_cleanup:
	if (uioinfo->irq != UIO_IRQ_NONE)
		irq_dispose_mapping(uioinfo->irq);

	kfree(uioinfo);
	return ret;
}

static int __devexit mbref_reg_of_remove(struct of_device *op)
{
	struct mbref_reg_platdata *priv = dev_get_drvdata(&op->dev);

	uio_unregister_device(priv->uioinfo);

	if (priv->uioinfo->irq != UIO_IRQ_NONE)
		irq_dispose_mapping(priv->uioinfo->irq);

	kfree(priv->uioinfo);
	kfree(priv);
	return 0;
}

/* work with hotplug and coldplug */
MODULE_ALIAS("platform:"DRIVER_NAME);

static const struct of_device_id mbref_reg_of_match[] = {
	{ .compatible = "xlnx,plbv46-mbref-reg-1.00.a", },
	{ /* end of list */ },
};
MODULE_DEVICE_TABLE(of, mbref_reg_of_match);

static struct of_platform_driver mbref_reg_driver = {
	.match_table	= mbref_reg_of_match,
	.probe		= mbref_reg_of_probe,
	.remove		= __devexit_p(mbref_reg_of_remove),
	.driver		= {
		.owner	= THIS_MODULE,
		.name	= DRIVER_NAME,
	},
};

/*
 * mbref_reg_init - function to insert this module into kernel space
 *
 * This is the first of two exported functions to handle inserting this
 * code into a running kernel
 *
 * Returns 0 if successfull, otherwise -1
 */

static int __init mbref_reg_init(void)
{
	return of_register_platform_driver(&mbref_reg_driver);
}

/*
 * mbref_reg_exit - function to cleanup this module from kernel space
 *
 * This is the second of two exported functions to handle cleanup this
 * code from a running kernel
 */

static void __exit mbref_reg_exit(void)
{
	of_unregister_platform_driver(&mbref_reg_driver);
}

module_init(mbref_reg_init);
module_exit(mbref_reg_exit);

MODULE_AUTHOR("linz@li-pro.net");
MODULE_DESCRIPTION("MicroBlaze References simple register bank for PLB v4.6.");
MODULE_LICENSE("GPL v2");

