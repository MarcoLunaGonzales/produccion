/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author wchoquehuanca
 */
public class ProgramaProduccionDevolucionMaterial extends AbstractBean{
   
    
    
    private ProgramaProduccion programaProduccion=new ProgramaProduccion();
    private String codProgramaProduccionDevolucionMaterial="";
    private EstadoReferencial estadoDevolucionMaterial= new EstadoReferencial();
    private Date fechaRegistro = new Date();
    
    public ProgramaProduccionDevolucionMaterial() {
    }

   

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public String getCodProgramaProduccionDevolucionMaterial() {
        return codProgramaProduccionDevolucionMaterial;
    }

    public void setCodProgramaProduccionDevolucionMaterial(String codProgramaProduccionDevolucionMaterial) {
        this.codProgramaProduccionDevolucionMaterial = codProgramaProduccionDevolucionMaterial;
    }

    public EstadoReferencial getEstadoDevolucionMaterial() {
        return estadoDevolucionMaterial;
    }

    public void setEstadoDevolucionMaterial(EstadoReferencial estadoDevolucionMaterial) {
        this.estadoDevolucionMaterial = estadoDevolucionMaterial;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    
}
