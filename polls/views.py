from django.shortcuts import render
from django.http import HttpResponse


def index(request):
    return HttpResponse("Hello, world. You're at the polls index. personel web page")
# Create your views here.

def index(request):
    return render(request, 'polls/index.html')
