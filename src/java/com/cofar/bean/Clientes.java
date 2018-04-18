/*
 * Clientes.java
 * Created on 25 de febrero de 2008, 17:35
 */

package com.cofar.bean;

import java.util.Date;

/**
 * @author Gabriela Quelali
 * @company COFAR
 */
public class Clientes  extends AbstractBean{
    
    /** Creates a new instance of Cliente */
    
    private String codCliente="";
    private CadenasCliente cadenaCliente=new CadenasCliente();
    private String nombreCliente="";
    private String nitCliente="";
    private String dirCliente="";
    private String telf1Cliente="";
    private String telf2Cliente="";
    private String telf3Cliente="";
    private String telf4Cliente="";
    private String nroDirCliente="";
    private String entreDir1="";
    private String entreDir2="";
    private String nombreFactura="";
    private Zona zona=new Zona();
    private String faxCliente="";
    private String emailCliente="";
    private ClasificacionCliente clasificacionCliente=new ClasificacionCliente();
    private RedesCliente redesCliente=new RedesCliente();
    private TiposCliente tipoCliente=new TiposCliente();
    private CategoriasCliente categoriaCliente=new CategoriasCliente();
    private CategoriasCobranzaCliente categoriaCobranzaCliente=new CategoriasCobranzaCliente();
    private String diasCreditoCliente="";
    private String creditoCliente="";
    private double montoMaxCreCliente=0;
    private double montoMinCreCliente=0;
    private EstadosCliente estadoCliente =new EstadosCliente();
    private AreasEmpresa areasEmpresa =new AreasEmpresa();
    private Distrito distrito=new Distrito();
    private TiposVia tiposVia=new TiposVia();
    private String nombreClienteOpcional="";
    private Date fechaCreacionCliente=new Date();
    private Boolean checkedCliente=new Boolean(false);
    private int cantDiasCredito=0;
    
    public Clientes() {
    }
    
    public String getCodCliente() {
        return codCliente;
    }
    
    public void setCodCliente(String codCliente) {
        this.codCliente = codCliente;
    }
    
    public CadenasCliente getCadenaCliente() {
        return cadenaCliente;
    }
    
    public void setCadenaCliente(CadenasCliente cadenaCliente) {
        this.cadenaCliente = cadenaCliente;
    }
    
    public String getNombreCliente() {
        return nombreCliente;
    }
    
    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }
    
    public String getNitCliente() {
        return nitCliente;
    }
    
    public void setNitCliente(String nitCliente) {
        this.nitCliente = nitCliente;
    }
    
    public String getDirCliente() {
        return dirCliente;
    }
    
    public void setDirCliente(String dirCliente) {
        this.dirCliente = dirCliente;
    }
    
    
    
    public Zona getZona() {
        return zona;
    }
    
    public void setZona(Zona zona) {
        this.zona = zona;
    }
    
    public String getFaxCliente() {
        return faxCliente;
    }
    
    public void setFaxCliente(String faxCliente) {
        this.faxCliente = faxCliente;
    }
    
    public String getEmailCliente() {
        return emailCliente;
    }
    
    public void setEmailCliente(String emailCliente) {
        this.emailCliente = emailCliente;
    }
    
    public TiposCliente getTipoCliente() {
        return tipoCliente;
    }
    
    public void setTipoCliente(TiposCliente tipoCliente) {
        this.tipoCliente = tipoCliente;
    }
    
    public CategoriasCliente getCategoriaCliente() {
        return categoriaCliente;
    }
    
    public void setCategoriaCliente(CategoriasCliente categoriaCliente) {
        this.categoriaCliente = categoriaCliente;
    }
    
    public String getDiasCreditoCliente() {
        return diasCreditoCliente;
    }
    
    public void setDiasCreditoCliente(String diasCreditoCliente) {
        this.diasCreditoCliente = diasCreditoCliente;
    }
    
    public String getCreditoCliente() {
        return creditoCliente;
    }
    
    public void setCreditoCliente(String creditoCliente) {
        this.creditoCliente = creditoCliente;
    }
    
    public double getMontoMaxCreCliente() {
        return montoMaxCreCliente;
    }
    
    public void setMontoMaxCreCliente(double montoMaxCreCliente) {
        this.montoMaxCreCliente = montoMaxCreCliente;
    }
    
    public double getMontoMinCreCliente() {
        return montoMinCreCliente;
    }
    
    public void setMontoMinCreCliente(double montoMinCreCliente) {
        this.montoMinCreCliente = montoMinCreCliente;
    }
    
    public EstadosCliente getEstadoCliente() {
        return estadoCliente;
    }
    
    public void setEstadoCliente(EstadosCliente estadoCliente) {
        this.estadoCliente = estadoCliente;
    }
    
    public ClasificacionCliente getClasificacionCliente() {
        return clasificacionCliente;
    }
    
    public void setClasificacionCliente(ClasificacionCliente clasificacionCliente) {
        this.clasificacionCliente = clasificacionCliente;
    }
    
    public RedesCliente getRedesCliente() {
        return redesCliente;
    }
    
    public void setRedesCliente(RedesCliente redesCliente) {
        this.redesCliente = redesCliente;
    }
    
    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }
    
    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }
    
    public String getNroDirCliente() {
        return nroDirCliente;
    }
    
    public void setNroDirCliente(String nroDirCliente) {
        this.nroDirCliente = nroDirCliente;
    }
    
    public String getEntreDir1() {
        return entreDir1;
    }
    
    public void setEntreDir1(String entreDir1) {
        this.entreDir1 = entreDir1;
    }
    
    public String getEntreDir2() {
        return entreDir2;
    }
    
    public void setEntreDir2(String entreDir2) {
        this.entreDir2 = entreDir2;
    }
    
    public Distrito getDistrito() {
        return distrito;
    }
    
    public void setDistrito(Distrito distrito) {
        this.distrito = distrito;
    }
    
    public TiposVia getTiposVia() {
        return tiposVia;
    }
    
    public void setTiposVia(TiposVia tiposVia) {
        this.tiposVia = tiposVia;
    }
    
    public String getTelf1Cliente() {
        return telf1Cliente;
    }
    
    public void setTelf1Cliente(String telf1Cliente) {
        this.telf1Cliente = telf1Cliente;
    }
    
    public String getTelf2Cliente() {
        return telf2Cliente;
    }
    
    public void setTelf2Cliente(String telf2Cliente) {
        this.telf2Cliente = telf2Cliente;
    }
    
    public String getTelf3Cliente() {
        return telf3Cliente;
    }
    
    public void setTelf3Cliente(String telf3Cliente) {
        this.telf3Cliente = telf3Cliente;
    }
    
    public String getTelf4Cliente() {
        return telf4Cliente;
    }
    
    public void setTelf4Cliente(String telf4Cliente) {
        this.telf4Cliente = telf4Cliente;
    }

    public String getNombreFactura() {
        return nombreFactura;
    }

    public void setNombreFactura(String nombreFactura) {
        this.nombreFactura = nombreFactura;
    }

    public CategoriasCobranzaCliente getCategoriaCobranzaCliente() {
        return categoriaCobranzaCliente;
    }

    public void setCategoriaCobranzaCliente(CategoriasCobranzaCliente categoriaCobranzaCliente) {
        this.categoriaCobranzaCliente = categoriaCobranzaCliente;
    }

    public String getNombreClienteOpcional() {
        return nombreClienteOpcional;
    }

    public void setNombreClienteOpcional(String nombreClienteOpcional) {
        this.nombreClienteOpcional = nombreClienteOpcional;
    }

    public Date getFechaCreacionCliente() {
        return fechaCreacionCliente;
    }

    public void setFechaCreacionCliente(Date fechaCreacionCliente) {
        this.fechaCreacionCliente = fechaCreacionCliente;
    }

    public Boolean getCheckedCliente() {
        return checkedCliente;
    }

    public void setCheckedCliente(Boolean checkedCliente) {
        this.checkedCliente = checkedCliente;
    }

    public int getCantDiasCredito() {
        return cantDiasCredito;
    }

    public void setCantDiasCredito(int cantDiasCredito) {
        this.cantDiasCredito = cantDiasCredito;
    }
    
    
}
