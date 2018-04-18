/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author Osmar Hinojosa Miranda
 */
public class Proveedores {
    
    /** Creates a new instance of LineaMKT */
    private int codProveedor=0;
    private String nombreProveedor="";
    private String nitProveedor="";    
    //private PlanDeCuentas planDeCuentas=new PlanDeCuentas();
    private Boolean checked=new Boolean(false);
    private String alfanumerico="";
    private String nroOrden="";    

    public int getCodProveedor() {
        return codProveedor;
    }

    public void setCodProveedor(int codProveedor) {
        this.codProveedor = codProveedor;
    }

    

    public String getNombreProveedor() {
        return nombreProveedor;
    }

    public void setNombreProveedor(String nombreProveedor) {
        this.nombreProveedor = nombreProveedor;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public String getNitProveedor() {
        return nitProveedor;
    }

    public void setNitProveedor(String nitProveedor) {
        this.nitProveedor = nitProveedor;
    }
 

    public String getAlfanumerico() {
        System.out.println("get:alfanumerico:"+alfanumerico);
        return alfanumerico;
    }

    public void setAlfanumerico(String alfa) {
        
        System.out.println("alfa:"+alfa);
        System.out.println("alfanumerico :"+alfanumerico );
        
        this.alfanumerico = alfa;
        System.out.println("xx:"+alfanumerico);
    }

    public String getNroOrden() {
        return nroOrden;
    }

    public void setNroOrden(String nroOrden) {
        this.nroOrden = nroOrden;
    }
    
}
