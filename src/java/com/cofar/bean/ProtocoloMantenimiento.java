/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class ProtocoloMantenimiento extends AbstractBean 
{
    private int codProtocoloMantenimiento=0;
    private Maquinaria maquinaria=new Maquinaria();
    private PartesMaquinaria partesMaquinaria=new PartesMaquinaria();
    

    public ProtocoloMantenimiento() {
    }

    public int getCodProtocoloMantenimiento() {
        return codProtocoloMantenimiento;
    }

    public void setCodProtocoloMantenimiento(int codProtocoloMantenimiento) {
        this.codProtocoloMantenimiento = codProtocoloMantenimiento;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public PartesMaquinaria getPartesMaquinaria() {
        return partesMaquinaria;
    }

    public void setPartesMaquinaria(PartesMaquinaria partesMaquinaria) {
        this.partesMaquinaria = partesMaquinaria;
    }

   
}
