/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class MotivoEnvioCorreoAtlas extends AbstractBean
{
    private int codMotivoEnvioCorreoAtlas=0;
    private String nombreMotivoEnvioCorreoAtlas="";

    public MotivoEnvioCorreoAtlas() {
    }

    public int getCodMotivoEnvioCorreoAtlas() {
        return codMotivoEnvioCorreoAtlas;
    }

    public void setCodMotivoEnvioCorreoAtlas(int codMotivoEnvioCorreoAtlas) {
        this.codMotivoEnvioCorreoAtlas = codMotivoEnvioCorreoAtlas;
    }

    public String getNombreMotivoEnvioCorreoAtlas() {
        return nombreMotivoEnvioCorreoAtlas;
    }

    public void setNombreMotivoEnvioCorreoAtlas(String nombreMotivoEnvioCorreoAtlas) {
        this.nombreMotivoEnvioCorreoAtlas = nombreMotivoEnvioCorreoAtlas;
    }
    
    
}
