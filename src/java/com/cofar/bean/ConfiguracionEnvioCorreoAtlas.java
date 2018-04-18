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
public class ConfiguracionEnvioCorreoAtlas extends AbstractBean
{
    private Personal personal=new Personal();
    private MotivoEnvioCorreoAtlas motivoEnvioCorreoAtlas=new MotivoEnvioCorreoAtlas();

    public ConfiguracionEnvioCorreoAtlas() {
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public MotivoEnvioCorreoAtlas getMotivoEnvioCorreoAtlas() {
        return motivoEnvioCorreoAtlas;
    }

    public void setMotivoEnvioCorreoAtlas(MotivoEnvioCorreoAtlas motivoEnvioCorreoAtlas) {
        this.motivoEnvioCorreoAtlas = motivoEnvioCorreoAtlas;
    }
    
    
}
