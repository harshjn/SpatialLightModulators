# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 22:16:52 2017

@author: Admin
"""
#import slmpy
import time
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image

M_x=792; # x-resolution of SLM
M_y=600; # y-resolution of SLM
A=np.zeros([M_x,M_y])
pi=np.pi;

Cx=400; # x-Center of axicon pattern
Cy=210;

def phase2hamamatsu(Phase_xy):  # Hamamatsu SLM phase bit varies from 0 to 224
    for p in range(M_x):
        for q in range(M_y):
            Phase_xy[p][q]=np.mod(Phase_xy[p][q],2*pi)*224/(2*pi)
    return Phase_xy


# Generating image for the pattern around center (Cx,Cy)
for i in range(792):
    for j in range(600):
        n=20
        r_o=1e4;
        r=(i-Cx)**2+(j-Cy)**2
        theta=np.arctan((j-Cy)/(i-Cx+1e-6))
        A[i,j]=np.mod(n*theta-2*pi*r/r_o,2*pi)
        
im=A; # 8-bit Image from 0 to 255 (uint8)
im=phase2hamamatsu(im) 
im=np.transpose(im)
im=im.astype(np.uint8)
image=Image.fromarray(im)
image.save('Axicon.bmp')

         
            
#%%
import slmpy
import time
import numpy as np
from PIL import Image
slm = slmpy.SLMdisplay(isImageLock = True)
resX, resY = slm.getSize()
# We use images twice smaller than the resolution of the slm
i=0

testIMG = np.asarray(Image.open('Axicon.bmp'))
slm.updateArray(testIMG)
time.sleep(500)
slm.close()
