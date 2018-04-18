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
public class TiposPermisosEspecialesAtlas extends AbstractBean
{
    private int codTipoPermisoEspecialAtlas=0;
    private String nombreTipoPermisoEspecialAtlas="";

    public TiposPermisosEspecialesAtlas() {
    }

    public int getCodTipoPermisoEspecialAtlas() {
        return codTipoPermisoEspecialAtlas;
    }

    public void setCodTipoPermisoEspecialAtlas(int codTipoPermisoEspecialAtlas) {
        this.codTipoPermisoEspecialAtlas = codTipoPermisoEspecialAtlas;
    }

    public String getNombreTipoPermisoEspecialAtlas() {
        return nombreTipoPermisoEspecialAtlas;
    }

    public void setNombreTipoPermisoEspecialAtlas(String nombreTipoPermisoEspecialAtlas) {
        this.nombreTipoPermisoEspecialAtlas = nombreTipoPermisoEspecialAtlas;
    }
    
    
}
