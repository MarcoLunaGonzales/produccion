/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class ViasAdministracionProducto extends AbstractBean{
    private int codViaAdministracionProducto=0;
    private String nombreViaAdministracionProducto="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public ViasAdministracionProducto() {
    }

    public int getCodViaAdministracionProducto() {
        return codViaAdministracionProducto;
    }

    public void setCodViaAdministracionProducto(int codViaAdministracionProducto) {
        this.codViaAdministracionProducto = codViaAdministracionProducto;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getNombreViaAdministracionProducto() {
        return nombreViaAdministracionProducto;
    }

    public void setNombreViaAdministracionProducto(String nombreViaAdministracionProducto) {
        this.nombreViaAdministracionProducto = nombreViaAdministracionProducto;
    }
    


}
