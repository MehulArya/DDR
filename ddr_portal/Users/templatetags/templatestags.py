import base64
from django import template

register = template.Library()

@register.filter(name='b64encode')
def b64encode(value):
    """Convert binary data to base64 for embedding in HTML"""
    if value is None:
        return ''
    return base64.b64encode(value).decode('utf-8')
