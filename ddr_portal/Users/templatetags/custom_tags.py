# myapp/templatetags/custom_tags.py
import os
import base64
from django import template

register = template.Library()

@register.filter
def get_item(dictionary, key):
    """Safely get an item from a dictionary in Django templates."""
    if isinstance(dictionary, dict):
        return dictionary.get(key, '')
    return ''

@register.filter
def b64encode(value):
    """Base64 encode a value (bytes expected)."""
    if value is None:
        return ''
    return base64.b64encode(value).decode()

@register.filter
def file_extension(value):
    """Return the lowercase file extension of a filename."""
    return os.path.splitext(str(value))[-1].lower()
