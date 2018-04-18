/*
 * MaterialPromocional.java
 *
 * Created on 7 de mayo de 2008, 11:54 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author rei
 */
public class MaterialPromocional extends AbstractBean {
    
    /** Creates a new instance of MaterialPromocional */
    private String codMatPromocional="";
    private TiposMercaderia tipoMercaderiaBean=new TiposMercaderia();
    private LineaMKT lineMktBean=new LineaMKT();
    private Producto productoBean=new Producto();
    private String nombreMatPromocional="";
    private String obsMatPromocional="";
    private EstadoReferencial estadoReferencialBean=new EstadoReferencial();
    private int codTemp;
    private int cantidadMatPromocional=0;
            
    public MaterialPromocional() {
    }

    public String getCodMatPromocional() {
        return codMatPromocional;
    }

    public void setCodMatPromocional(String codMatPromocional) {
        this.codMatPromocional = codMatPromocional;
    }

    public TiposMercaderia getTipoMercaderiaBean() {
        return tipoMercaderiaBean;
    }

    public void setTipoMercaderiaBean(TiposMercaderia tipoMercaderiaBean) {
        this.tipoMercaderiaBean = tipoMercaderiaBean;
    }

    public LineaMKT getLineMktBean() {
        return lineMktBean;
    }

    public void setLineMktBean(LineaMKT lineMktBean) {
        this.lineMktBean = lineMktBean;
    }

    public Producto getProductoBean() {
        return productoBean;
    }

    public void setProductoBean(Producto productoBean) {
        this.productoBean = productoBean;
    }

    public String getNombreMatPromocional() {
        return nombreMatPromocional;
    }

    public void setNombreMatPromocional(String nombreMatPromocional) {
        this.nombreMatPromocional = nombreMatPromocional;
    }

    public String getObsMatPromocional() {
        return obsMatPromocional;
    }

    public void setObsMatPromocional(String obsMatPromocional) {
        this.obsMatPromocional = obsMatPromocional;
    }

    public EstadoReferencial getEstadoReferencialBean() {
        return estadoReferencialBean;
    }

    public void setEstadoReferencialBean(EstadoReferencial estadoReferencialBean) {
        this.estadoReferencialBean = estadoReferencialBean;
    }

    public int getCodTemp() {
        return codTemp;
    }

    public void setCodTemp(int codTemp) {
        this.codTemp = codTemp;
    }

    public int getCantidadMatPromocional() {
        return cantidadMatPromocional;
    }

    public void setCantidadMatPromocional(int cantidadMatPromocional) {
        this.cantidadMatPromocional = cantidadMatPromocional;
    }
    
}
