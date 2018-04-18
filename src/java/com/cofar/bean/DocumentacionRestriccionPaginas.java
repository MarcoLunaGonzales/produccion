/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class DocumentacionRestriccionPaginas extends AbstractBean{
    private Cargos cargos=new Cargos();
    private int paginaInicio=0;
    private int paginaFinal=0;

    public DocumentacionRestriccionPaginas() {
    }

    public Cargos getCargos() {
        return cargos;
    }

    public void setCargos(Cargos cargos) {
        this.cargos = cargos;
    }

    public int getPaginaFinal() {
        return paginaFinal;
    }

    public void setPaginaFinal(int paginaFinal) {
        this.paginaFinal = paginaFinal;
    }

    public int getPaginaInicio() {
        return paginaInicio;
    }

    public void setPaginaInicio(int paginaInicio) {
        this.paginaInicio = paginaInicio;
    }
    

}
