/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;


import com.cofar.bean.Documentacion;
import com.cofar.bean.Personal;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.richfaces.component.html.HtmlDataTable;


/**
 *
 * @author hvaldivia
 */

public class ManagedConfiguracionDocumentacionPreguntas {
    List personalConfiguracionList = new ArrayList();
    Personal personalSeleccionado = new Personal();
    HtmlDataTable personalConfiguracionDataTable = new HtmlDataTable();
    List documentosList = new ArrayList();
    HtmlDataTable documentosDataTable = new HtmlDataTable();
    Documentacion documentoSeleccionado = new Documentacion();
    

    /** Creates a new instance of ManagedConfiguracionDocumentacionPreguntas */
    public ManagedConfiguracionDocumentacionPreguntas() {
    }
    public String getCargarPersonalConfiguracion(){
        try {
            String consulta = "select p.cod_personal,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,p.nombre2_personal from personal p where p.COD_ESTADO_PERSONA = 1 order by p.AP_PATERNO_PERSONAL ";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            personalConfiguracionList.clear();
            while(rs.next()){
                Personal personal = new Personal();
                personal.setCodPersonal(rs.getString("cod_personal"));
                personal.setNombrePersonal(rs.getString("nombres_personal"));
                personal.setApPaternoPersonal(rs.getString("ap_paterno_personal"));
                personal.setApMaternoPersonal(rs.getString("ap_materno_personal"));
                personalConfiguracionList.add(personal);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String seleccionarPersonal_action(){
        personalSeleccionado = (Personal) personalConfiguracionDataTable.getRowData();
        return null;
    }
    public String getCargarConfiguracionPreguntasPersonal(){
        try {
            String consulta = " select d.COD_DOCUMENTO,a.NOMBRE_AREA_EMPRESA,m.NOMBRE_MAQUINA,t.NOMBRE_TIPO_DOCUMENTO_BPM_ISO,tb.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA" +
                    " from documentacion d" +
                    " inner join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = d.COD_AREA_EMPRESA" +
                    " inner join maquinarias m on m.COD_MAQUINA = d.COD_MAQUINA" +
                    " inner join TIPOS_DOCUMENTO_BPM_ISO t on t.COD_TIPO_DOCUMENTO_BPM_ISO =d.COD_TIPO_DOCUMENTO_BPM_ISO" +
                    " inner join TIPOS_DOCUMENTO_BIBLIOTECA tb on tb.COD_TIPO_DOCUMENTO_BIBLIOTECA = d.COD_TIPO_DOCUMENTO_BIBLIOTECA ";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            documentosList.clear();
            while(rs.next()){
                Documentacion d = new Documentacion();
                d.setCodDocumento(rs.getInt("cod_documento"));
                d.getAreasEmpresa().setNombreAreaEmpresa(rs.getString("nombre_area_empresa"));
                d.getMaquinaria().setNombreMaquina(rs.getString("nombre_maquina"));
                d.getTiposDocumentoBpmIso().setNombreTipoDocumentoBpmIso(rs.getString("nombre_tipo_documento_bpm_iso"));
                d.getTiposDocumentoBiblioteca().setNombreTipoDocumentoBiblioteca(rs.getString("NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA"));
                documentosList.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String documentoSeleccionado(){
        documentoSeleccionado = (Documentacion) documentosDataTable.getRowData();
        return null;
    }
}
