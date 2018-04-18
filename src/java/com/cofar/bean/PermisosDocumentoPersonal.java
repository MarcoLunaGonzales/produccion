/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class PermisosDocumentoPersonal extends AbstractBean {
    private Personal personal=new Personal();
    private Documentacion documentacion=new Documentacion();
    private boolean lectura=false;
    private boolean impresion=false;
    private boolean guardado=false;

    public PermisosDocumentoPersonal() {
    }

    public Documentacion getDocumentacion() {
        return documentacion;
    }

    public void setDocumentacion(Documentacion documentacion) {
        this.documentacion = documentacion;
    }

    public boolean isGuardado() {
        return guardado;
    }

    public void setGuardado(boolean guardado) {
        this.guardado = guardado;
    }

    public boolean isImpresion() {
        return impresion;
    }

    public void setImpresion(boolean impresion) {
        this.impresion = impresion;
    }

    public boolean isLectura() {
        return lectura;
    }

    public void setLectura(boolean lectura) {
        this.lectura = lectura;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    

}
