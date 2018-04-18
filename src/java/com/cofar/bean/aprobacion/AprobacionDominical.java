/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.aprobacion;

import com.cofar.bean.AbstractBean;

/**
 *
 * @author Ismael Juchazara
 */
public class AprobacionDominical extends AbstractBean {

    private int codigo;
    private int codGestion;
    private int codMes;
    private String gestion;
    private String mes;

    public AprobacionDominical(int codigo, int codGestion, int codMes, String gestion, String mes) {
        this.codigo = codigo;
        this.codGestion = codGestion;
        this.codMes = codMes;
        this.gestion = gestion;
        this.mes = mes;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public String getGestion() {
        return gestion;
    }

    public void setGestion(String gestion) {
        this.gestion = gestion;
    }

    public String getMes() {
        return mes;
    }

    public void setMes(String mes) {
        this.mes = mes;
    }

    /**
     * @return the codGestion
     */
    public int getCodGestion() {
        return codGestion;
    }

    /**
     * @param codGestion the codGestion to set
     */
    public void setCodGestion(int codGestion) {
        this.codGestion = codGestion;
    }

    /**
     * @return the codMes
     */
    public int getCodMes() {
        return codMes;
    }

    /**
     * @param codMes the codMes to set
     */
    public void setCodMes(int codMes) {
        this.codMes = codMes;
    }
}
