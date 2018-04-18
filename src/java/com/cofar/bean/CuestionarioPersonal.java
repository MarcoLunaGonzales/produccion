/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author aquispe
 */
public class CuestionarioPersonal extends AbstractBean{
    private int codCuestionarioPersonal=0;
    private Personal personal=new Personal();
    private Documentacion documentacion=new Documentacion();
    private Date fechaRegistro=new Date();
    private Date fechaRevision=new Date();
    public CuestionarioPersonal() {
    }

    public int getCodCuestionarioPersonal() {
        return codCuestionarioPersonal;
    }

    public void setCodCuestionarioPersonal(int codCuestionarioPersonal) {
        this.codCuestionarioPersonal = codCuestionarioPersonal;
    }

    public Documentacion getDocumentacion() {
        return documentacion;
    }

    public void setDocumentacion(Documentacion documentacion) {
        this.documentacion = documentacion;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public Date getFechaRevision() {
        return fechaRevision;
    }

    public void setFechaRevision(Date fechaRevision) {
        this.fechaRevision = fechaRevision;
    }
    

}
