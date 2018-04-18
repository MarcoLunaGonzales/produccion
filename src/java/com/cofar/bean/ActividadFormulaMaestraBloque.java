/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.List;

/**
 *
 * @author DASISAQ
 */
public class ActividadFormulaMaestraBloque extends AbstractBean{
    private int codActividadFormulaMaestraBloque=0;
    private String descripcion="";
    private Double horasHombreEstandar=0d;
    private List<ActividadesFormulaMaestra> actividadesFormulaMaestraList;

    public ActividadFormulaMaestraBloque() {
    }

    public int getCodActividadFormulaMaestraBloque() {
        return codActividadFormulaMaestraBloque;
    }

    public void setCodActividadFormulaMaestraBloque(int codActividadFormulaMaestraBloque) {
        this.codActividadFormulaMaestraBloque = codActividadFormulaMaestraBloque;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Double getHorasHombreEstandar() {
        return horasHombreEstandar;
    }

    public void setHorasHombreEstandar(Double horasHombreEstandar) {
        this.horasHombreEstandar = horasHombreEstandar;
    }

    public List<ActividadesFormulaMaestra> getActividadesFormulaMaestraList() {
        return actividadesFormulaMaestraList;
    }

    public void setActividadesFormulaMaestraList(List<ActividadesFormulaMaestra> actividadesFormulaMaestraList) {
        this.actividadesFormulaMaestraList = actividadesFormulaMaestraList;
    }
    
    public int getActividadesFormulaMaestraListTotalSize() {
        int cantidadRegistros=0;
        if(actividadesFormulaMaestraList!=null)
        {
            for(ActividadesFormulaMaestra bean:actividadesFormulaMaestraList)
            {
                cantidadRegistros+=(bean.getActividadesFormulaMaestraHorasEstandarMaquinariaListSize() == 0?1:bean.getActividadesFormulaMaestraHorasEstandarMaquinariaListSize());
            }
        }
        return cantidadRegistros;
    }
    
    
    
}
