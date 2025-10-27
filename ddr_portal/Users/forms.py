# your_app/forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
from faculty.models import FacultyTeacher

class CustomUserCreationForm(UserCreationForm):
    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']

    def clean_email(self):
        email = self.cleaned_data.get('email')

        if not email.endswith('@skit.ac.in'):
            raise ValidationError("Email must be a valid @skit.ac.in address.")

        if not FacultyTeacher.objects.filter(email=email).exists():
            raise ValidationError("This email is not registered as a faculty.")

        return email

class CustomLoginForm(AuthenticationForm):
    username = forms.CharField(label="Username")
    password = forms.CharField(label="Password", widget=forms.PasswordInput)