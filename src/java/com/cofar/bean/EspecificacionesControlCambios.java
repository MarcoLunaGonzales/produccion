/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 * @author DASISAQ-
 */
public class EspecificacionesControlCambios extends AbstractBean{
    private int codEspecificacionControlCambios=0;
    private String nombreEspecificacionControlCambios="";
    private List<RegistroControlCambiosActividadPropuesta> registroControlCambiosActividadPropuestList=null;

    public EspecificacionesControlCambios() {
    }

    public int getCodEspecificacionControlCambios() {
        return codEspecificacionControlCambios;
    }

    public void setCodEspecificacionControlCambios(int codEspecificacionControlCambios) {
        this.codEspecificacionControlCambios = codEspecificacionControlCambios;
    }

    public String getNombreEspecificacionControlCambios() {
        return nombreEspecificacionControlCambios;
    }

    public void setNombreEspecificacionControlCambios(String nombreEspecificacionControlCambios) {
        this.nombreEspecificacionControlCambios = nombreEspecificacionControlCambios;
    }

    public List<RegistroControlCambiosActividadPropuesta> getRegistroControlCambiosActividadPropuestList() {
        return registroControlCambiosActividadPropuestList;
    }

    public void setRegistroControlCambiosActividadPropuestList(List<RegistroControlCambiosActividadPropuesta> registroControlCambiosActividadPropuestList) {
        this.registroControlCambiosActividadPropuestList = registroControlCambiosActividadPropuestList;
    }

    public int getRegistroControlCambiosActividadPropuestListSize()
    {
        return (registroControlCambiosActividadPropuestList!=null?registroControlCambiosActividadPropuestList.size():0);
    }

}
