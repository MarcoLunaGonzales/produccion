/*
 * EstadoProducto.java
 *
 * Created on 18 de marzo de 2008, 05:31 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class EstadoSolicitudMantenimiento {
    
    /** Creates a new instance of EstadoProducto */
    private int codEstadoSolicitudMantenimiento=0;
    private String nombreEstadoSolicitudMantenimiento="";

    public int getCodEstadoSolicitudMantenimiento() {
        return codEstadoSolicitudMantenimiento;
    }

    public void setCodEstadoSolicitudMantenimiento(int codEstadoSolicitudMantenimiento) {
        this.codEstadoSolicitudMantenimiento = codEstadoSolicitudMantenimiento;
    }

   

    public String getNombreEstadoSolicitudMantenimiento() {
        return nombreEstadoSolicitudMantenimiento;
    }

    public void setNombreEstadoSolicitudMantenimiento(String nombreEstadoSolicitudMantenimiento) {
        this.nombreEstadoSolicitudMantenimiento = nombreEstadoSolicitudMantenimiento;
    }

  

}
