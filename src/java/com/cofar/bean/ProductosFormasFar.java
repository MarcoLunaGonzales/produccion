/*
 * ProductosFormasFar.java
 *
 * Created on 13 de mayo de 2008, 16:10
 */

package com.cofar.bean;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class ProductosFormasFar {
    
    /** Creates a new instance of ProductosFormasFar */
    private String codProdformasfar="";
    private String concentracion="";
    private FormasFarmaceuticas formaFarmaceuticas=new FormasFarmaceuticas ();
    private Producto producto=new Producto ();
    private SaboresProducto saboresProducto=new SaboresProducto();
    
    public ProductosFormasFar() {
    }

    public String getCodProdformasfar() {
        return codProdformasfar;
    }

    public void setCodProdformasfar(String codProdformasfar) {
        this.codProdformasfar = codProdformasfar;
    }

    public String getConcentracion() {
        return concentracion;
    }

    public void setConcentracion(String concentracion) {
        this.concentracion = concentracion;
    }

    public FormasFarmaceuticas getFormaFarmaceuticas() {
        return formaFarmaceuticas;
    }

    public void setFormaFarmaceuticas(FormasFarmaceuticas formaFarmaceuticas) {
        this.formaFarmaceuticas = formaFarmaceuticas;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public SaboresProducto getSaboresProducto() {
        return saboresProducto;
    }

    public void setSaboresProducto(SaboresProducto saboresProducto) {
        this.saboresProducto = saboresProducto;
    }
    
}
