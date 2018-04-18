/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class LiberacionLotes extends AbstractBean{

    private TiposLiberacionLote tiposLiberacionLote=new TiposLiberacionLote();
    private String codLoteProduccion="";
    private Personal personal=new Personal();
    private Date fechaLiberacion=new Date();
    
    public LiberacionLotes() {
    }

    public TiposLiberacionLote getTiposLiberacionLote() {
        return tiposLiberacionLote;
    }

    public void setTiposLiberacionLote(TiposLiberacionLote tiposLiberacionLote) {
        this.tiposLiberacionLote = tiposLiberacionLote;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public Date getFechaLiberacion() {
        return fechaLiberacion;
    }

    public void setFechaLiberacion(Date fechaLiberacion) {
        this.fechaLiberacion = fechaLiberacion;
    }

    public String getCodLoteProduccion() {
        return codLoteProduccion;
    }

    public void setCodLoteProduccion(String codLoteProduccion) {
        this.codLoteProduccion = codLoteProduccion;
    }
    
    
    
}
