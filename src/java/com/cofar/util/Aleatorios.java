/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.util;

/**
 *
 * @author aquispe
 */
public class Aleatorios {
   private int n;
    int v[]=new int[100];
    public Aleatorios(int _n) {
        n=_n;
        for(int x=0;x<n;x++) {
            v[x]=0;}
    }

    public  int[] generar(int n,int a, int b) {
        int data[]=new int[n];


        int i=0;
        int p;
        while (i<n) {
            p=(int)(Math.random()*b);
            if(p>=a) {
                int k=0;
                while((p!=v[k])&&(k<n)) {
                    v[i]=p;
                    k++;
                }
                i++;
            }
        }
        System.out.println("\nNumeros aleatorios generados con exito!");
        System.out.println("\nLos numeros generados son: ");
        for (int j=0;j<n;j++) {
            // System.out.println(v[j]);
            data[j]=v[j];
        }
        return data;
    }
   

    public static void main(String[] argv) {

        Runnable runnable=new Runnable() {
            public void run()  {

                try {
                    int ran=0x00000B;
                    while(true){
                        Thread.sleep(1000);
                        ran++;
                        System.out.println(ran);
                        //int number=(Math.random())*ran;
                       // System.out.println(number);

                    }

                } catch (InterruptedException e) {
                    e.printStackTrace();
                }






            }
        };

        Thread hilo=new Thread(runnable);
        hilo.start();

    }
}
