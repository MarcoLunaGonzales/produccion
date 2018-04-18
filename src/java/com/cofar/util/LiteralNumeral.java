/*
 * LiteralNumeral.java
 *
 * Created on 28 de octubre de 2008, 9:25
 */

package com.cofar.util;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class LiteralNumeral {
    
    /** Creates a new instance of LiteralNumeral */
    private String literal="";
    public LiteralNumeral() {
    }
    public void unidades(int n){
        String unidad="";
        if(n>9){
            System.out.println("Error, no son unidades");
            return;
        }
        switch (n){
            case 1: unidad="UN"; break;
            case 2: unidad="DOS"; break;
            case 3: unidad="TRES"; break;
            case 4: unidad="CUATRO"; break;
            case 5: unidad="CINCO"; break;
            case 6: unidad="SEIS"; break;
            case 7: unidad="SIETE"; break;
            case 8: unidad="OCHO"; break;
            case 9: unidad="NUEVE"; break;
            case 0: unidad="CERO"; break;
        }
        literal+=unidad;
        System.out.print(unidad);
    }
    public void decenas(int n){
        String decenas="";
        int d, u;
        d=n/10;
        u=n%10;
        if(d>9){
            System.out.print("Error, No son decenas");
            return;
        }
        if(d==0){
            unidades(n);
            return;
        }
        if(d==1){
            if(u==0){
                literal+="DIEZ";
                System.out.print("diez");
            }else if(u==1){
                literal+="ONCE";
                System.out.print("once");
            }else if(u==2){
                literal+="DOCE";
                System.out.print("doce");
            }else if(u==3){
                literal+="TRECE";
                System.out.print("trece");
            }else if(u==4){
                literal+="CATORCE";
                System.out.print("catorce");
            }else if(u==5){
                literal+="QUINCE";
                System.out.print("quince");
            }else{
                literal+="DIECI";
                System.out.print("dieci");
                unidades(u);
            }
        }else if (d==2){
            if(u==0){
                literal+="VEINTE";
                System.out.print("veinte");
            }else{
                literal+="VEINTE";
                System.out.print("veinti");
                unidades(u);
            }
        }else{
            switch(d){
                case 3: decenas="TREINTA"; break;
                case 4: decenas="CUARENTA"; break;
                case 5: decenas="CINCUENTA"; break;
                case 6: decenas="SESENTA"; break;
                case 7: decenas="SETENTA"; break;
                case 8: decenas="OCHENTA"; break;
                case 9: decenas="NOVENTA"; break;
            }
            literal+=decenas;
            System.out.print(decenas);
            if(u!=0){
                System.out.print(" Y ");
                literal+=" Y ";
                unidades(u);
            }
        }
    }
    public void centenas(int n){
        String centenas="";
        int c, r;
        c=n/100;
        r=n%100;
        if(c>9){
            System.out.print("Error, No son centenas");
            return;
        }
        if(c==0){
            decenas(n);
            return;
        }
        if(c==1){
            if(r==0){
                literal+="CIEN";
                System.out.print("cien");
            }else{
                literal+="CIENTO ";
                System.out.print("ciento ");
            }
        }else if(c==5){
            literal+="QUINIENTOS ";
            System.out.print("quinientos ");
        }else{
            if(c==7){
                literal+="SETE";
                System.out.print("sete");
            }else if(c==9){
                literal+="NOVE";
                System.out.print("nove");
            }else{
                unidades(c);
            }
            literal+="CIENTOS ";
            System.out.print("cientos ");
        }
        if(r!=0){
            decenas(r);
        }
    }
    public void millares(int n){
        int millar, r;
        millar=n/1000;
        r=n%1000;
        if(millar>999){
            System.out.print("Error, No son millares");
            return;
        }
        if(millar==0){
            centenas(n);
            return;
        }else{
            centenas(millar);
            literal+=" MIL ";
            System.out.print(" mil ");
            if(r!=0){
                centenas(r);
            }
        }
    }
    public void millones(int n){
        int millon, r;
        millon=n/1000000;
        r=n%1000000;
        if(millon>999){
            System.out.print("Error, No son millones");
            return;
        }
        if(millon==0){
            millares(n);
            return;
        }else{
            centenas(millon);
            if(millon==1){
                literal+=" MILLON ";
                System.out.print(" millon ");
            }else{
                literal+=" MILLONES ";
                System.out.print(" millones ");
            }
            if(r!=0){
                millares(r);
            }
        }
    }
    public String billones(int n){
        int billon, r;
        billon=n/1000000000;
        r=n/1000000000;
        if(billon>999){
            System.out.print("Error, No son miles de millones");
            return literal;
        }
        if(billon==0){
            millones(n);
            return literal;
        }else{
            centenas(billon);
            if(billon==1){
                literal+=" MIL MILLON";
                System.out.print(" mil millon ");
            }else{
                literal+=" MIL MILLONES ";
                System.out.print(" mil millones ");
            }
            if(r!=0){
                millones(r);
            }
        }
        return literal;
    }
    public static void main(String[] args) {
        LiteralNumeral literal=new LiteralNumeral();
        int a=17596;
        
        String cantidad=literal.billones(a);
        System.out.println("cantidad:"+cantidad);



        
        
    }
}
