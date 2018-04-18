/*
 * solicitudCompraMantenimiento.java
 *
 * Created on 1 de septiembre de 2010, 03:52 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Guery Garcia Jaldin
 */
public class solicitudCompraMantenimiento {
    
    private int cantNro;
    private String cantMateriale;
    private String cantSolicitada;
    private String cantStock;
    private int cantDiferencia;
    private String cantFecha;
    
    /** Creates a new instance of solicitudCompraMantenimiento */
    public solicitudCompraMantenimiento() {
    }

    public int getCantNro() {
        return cantNro;
    }

    public void setCantNro(int cantNro) {
        this.cantNro = cantNro;
    }

    public String getCantMateriale() {
        return cantMateriale;
    }

    public void setCantMateriale(String cantMateriale) {
        this.cantMateriale = cantMateriale;
    }

    public String getCantSolicitada() {
        return cantSolicitada;
    }

    public void setCantSolicitada(String cantSolicitada) {
        this.cantSolicitada = cantSolicitada;
    }

    public String getCantStock() {
        return cantStock;
    }

    public void setCantStock(String cantStock) {
        this.cantStock = cantStock;
    }

    public int getCantDiferencia() {
        return cantDiferencia;
    }

    public void setCantDiferencia(int cantDiferencia) {
        this.cantDiferencia = cantDiferencia;
    }

    public String getCantFecha() {
        return cantFecha;
    }

    public void setCantFecha(String cantFecha) {
        this.cantFecha = cantFecha;
    }
    
}
