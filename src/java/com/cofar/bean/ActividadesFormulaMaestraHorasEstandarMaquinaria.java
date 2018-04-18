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
public class ActividadesFormulaMaestraHorasEstandarMaquinaria extends AbstractBean
{
    private ActividadesFormulaMaestra actividadesFormulaMaestra=new ActividadesFormulaMaestra();
    private int codActividadesFormulaMaestraHorasEstandarMaquinaria=0;
    private Maquinaria maquinaria=new Maquinaria();
    private Double horasMaquinaEstandar=0d;
    private Double horasHombreEstandar=0d;

    public ActividadesFormulaMaestraHorasEstandarMaquinaria() {
    }

    public int getCodActividadesFormulaMaestraHorasEstandarMaquinaria() {
        return codActividadesFormulaMaestraHorasEstandarMaquinaria;
    }

    public void setCodActividadesFormulaMaestraHorasEstandarMaquinaria(int codActividadesFormulaMaestraHorasEstandarMaquinaria) {
        this.codActividadesFormulaMaestraHorasEstandarMaquinaria = codActividadesFormulaMaestraHorasEstandarMaquinaria;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public Double getHorasMaquinaEstandar() {
        return horasMaquinaEstandar;
    }

    public void setHorasMaquinaEstandar(Double horasMaquinaEstandar) {
        this.horasMaquinaEstandar = horasMaquinaEstandar;
    }

    public Double getHorasHombreEstandar() {
        return horasHombreEstandar;
    }

    public void setHorasHombreEstandar(Double horasHombreEstandar) {
        this.horasHombreEstandar = horasHombreEstandar;
    }

    public ActividadesFormulaMaestra getActividadesFormulaMaestra() {
        return actividadesFormulaMaestra;
    }

    public void setActividadesFormulaMaestra(ActividadesFormulaMaestra actividadesFormulaMaestra) {
        this.actividadesFormulaMaestra = actividadesFormulaMaestra;
    }
    
}
