/*
 * PresentacionesProductoMaterialPromocional.java
 *
 * Created on 15 de septiembre de 2008, 16:43
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Rene
 */
public class PresentacionesProductoMaterialPromocional {
    
    /** Creates a new instance of PresentacionesProductoMaterialPromocional */
    private MaterialPromocional materialPromocional =new MaterialPromocional();
    private PresentacionesProducto presentacionesProducto=new PresentacionesProducto();
    private int cantMaterialPromocional=0;
    public PresentacionesProductoMaterialPromocional() {
    }

    public MaterialPromocional getMaterialPromocional() {
        return materialPromocional;
    }

    public void setMaterialPromocional(MaterialPromocional materialPromocional) {
        this.materialPromocional = materialPromocional;
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public int getCantMaterialPromocional() {
        return cantMaterialPromocional;
    }

    public void setCantMaterialPromocional(int cantMaterialPromocional) {
        this.cantMaterialPromocional = cantMaterialPromocional;
    }
    
}
