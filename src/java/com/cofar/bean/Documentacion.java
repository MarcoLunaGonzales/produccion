/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author hvaldivia
 */
public class Documentacion  extends AbstractBean{
    private int codDocumento = 0;
    private String nombreDocumento = "";
    private String codigoDocumento = "";
    private String codigoNuevo="";
    private TiposDocumentoBiblioteca tiposDocumentoBiblioteca = new TiposDocumentoBiblioteca();
    private TiposDocumentoBpmIso tiposDocumentoBpmIso = new TiposDocumentoBpmIso();
    private AreasEmpresa areasEmpresa = new AreasEmpresa();
    private Maquinaria maquinaria=new Maquinaria();
    /*private List<VersionDocumentacion> versionDocumentacionList=null;
    private ComponentesProd componentesProd=new ComponentesProd();*/
    int nroPreguntasCuestionario = 0;
    public Documentacion() {
    }
    /*public int getTamLista()
    {
          return versionDocumentacionList.size();
    }*/
    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public int getCodDocumento() {
        return codDocumento;
    }

    public void setCodDocumento(int codDocumento) {
        this.codDocumento = codDocumento;
    }

    public String getCodigoDocumento() {
        return codigoDocumento;
    }

    public void setCodigoDocumento(String codigoDocumento) {
        this.codigoDocumento = codigoDocumento;
    }

    public String getNombreDocumento() {
        return nombreDocumento;
    }

    public void setNombreDocumento(String nombreDocumento) {
        this.nombreDocumento = nombreDocumento;
    }


    public TiposDocumentoBiblioteca getTiposDocumentoBiblioteca() {
        return tiposDocumentoBiblioteca;
    }

    public void setTiposDocumentoBiblioteca(TiposDocumentoBiblioteca tiposDocumentoBiblioteca) {
        this.tiposDocumentoBiblioteca = tiposDocumentoBiblioteca;
    }

    public TiposDocumentoBpmIso getTiposDocumentoBpmIso() {
        return tiposDocumentoBpmIso;
    }

    public void setTiposDocumentoBpmIso(TiposDocumentoBpmIso tiposDocumentoBpmIso) {
        this.tiposDocumentoBpmIso = tiposDocumentoBpmIso;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

   /*public List<VersionDocumentacion> getVersionDocumentacionList() {
        return versionDocumentacionList;
    }

    public void setVersionDocumentacionList(List<VersionDocumentacion> versionDocumentacionList) {
        this.versionDocumentacionList = versionDocumentacionList;
    }*/

    public int getNroPreguntasCuestionario() {
        return nroPreguntasCuestionario;
    }

    public void setNroPreguntasCuestionario(int nroPreguntasCuestionario) {
        this.nroPreguntasCuestionario = nroPreguntasCuestionario;
    }

    /*public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }*/

    public String getCodigoNuevo() {
        return codigoNuevo;
    }

    public void setCodigoNuevo(String codigoNuevo) {
        this.codigoNuevo = codigoNuevo;
    }
    
    
    
}
