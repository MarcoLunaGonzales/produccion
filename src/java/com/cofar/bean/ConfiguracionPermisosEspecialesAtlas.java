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
public class ConfiguracionPermisosEspecialesAtlas extends AbstractBean 
{
    private int codConfiguracionPermisoEspecialAtlas=0;
    private Personal personal=new Personal();
    private TiposPermisosEspecialesAtlas tiposPermisosEspecialesAtlas=new TiposPermisosEspecialesAtlas();

    public ConfiguracionPermisosEspecialesAtlas() {
    }

    public int getCodConfiguracionPermisoEspecialAtlas() {
        return codConfiguracionPermisoEspecialAtlas;
    }

    public void setCodConfiguracionPermisoEspecialAtlas(int codConfiguracionPermisoEspecialAtlas) {
        this.codConfiguracionPermisoEspecialAtlas = codConfiguracionPermisoEspecialAtlas;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public TiposPermisosEspecialesAtlas getTiposPermisosEspecialesAtlas() {
        return tiposPermisosEspecialesAtlas;
    }

    public void setTiposPermisosEspecialesAtlas(TiposPermisosEspecialesAtlas tiposPermisosEspecialesAtlas) {
        this.tiposPermisosEspecialesAtlas = tiposPermisosEspecialesAtlas;
    }
    
    
}
