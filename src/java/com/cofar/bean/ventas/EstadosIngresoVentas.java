/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.ventas;

import com.cofar.bean.AbstractBean;

/**
 *
 * @author DASISAQ
 */
public class EstadosIngresoVentas extends AbstractBean
{
    private int codEstadoIngresoVentas=0;
    private String nombreEstadosIngresoVentas="";
    private String nombreEstadoIngresoVentasCuarentena="";

    public EstadosIngresoVentas() {
    }

    public int getCodEstadoIngresoVentas() {
        return codEstadoIngresoVentas;
    }

    public void setCodEstadoIngresoVentas(int codEstadoIngresoVentas) {
        this.codEstadoIngresoVentas = codEstadoIngresoVentas;
    }

    public String getNombreEstadosIngresoVentas() {
        return nombreEstadosIngresoVentas;
    }

    public void setNombreEstadosIngresoVentas(String nombreEstadosIngresoVentas) {
        this.nombreEstadosIngresoVentas = nombreEstadosIngresoVentas;
    }

    public String getNombreEstadoIngresoVentasCuarentena() {
        return nombreEstadoIngresoVentasCuarentena;
    }

    public void setNombreEstadoIngresoVentasCuarentena(String nombreEstadoIngresoVentasCuarentena) {
        this.nombreEstadoIngresoVentasCuarentena = nombreEstadoIngresoVentasCuarentena;
    }

    
    
}
