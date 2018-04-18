/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class LugaresAcond implements Cloneable{
    int codLugarAcond = 0;
    String nombreLugarAcond = "";

    public int getCodLugarAcond() {
        return codLugarAcond;
    }

    public void setCodLugarAcond(int codLugarAcond) {
        this.codLugarAcond = codLugarAcond;
    }

    public String getNombreLugarAcond() {
        return nombreLugarAcond;
    }

    public void setNombreLugarAcond(String nombreLugarAcond) {
        this.nombreLugarAcond = nombreLugarAcond;
    }

    public Object clone()
    {
        Object obj=null;
        try
        {
            obj=super.clone();
        }
        catch(CloneNotSupportedException ex)
        {
            ex.printStackTrace();
            System.out.println("no se puede clonar");
        }
        return obj;
    }
    
}
