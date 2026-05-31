import frappe
from dummy_app import __version__

no_cache = 1


def get_context(context):
    context.version = __version__
    context.site = frappe.local.site
    context.now = frappe.utils.now_datetime()
    return context
