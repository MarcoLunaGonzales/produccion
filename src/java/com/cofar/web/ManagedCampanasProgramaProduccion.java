/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.CampaniaProgramaProduccion;
import com.cofar.bean.CampaniaProgramaProduccionDetalle;
import com.cofar.bean.ComponentesProd;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.ProgramaProduccionPeriodo;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ-
 */

public class ManagedCampanasProgramaProduccion extends ManagedBean{

    /** Creates a new instance of ManagedCampanasProgramaProduccion */
    private Connection con=null;
    private List<CampaniaProgramaProduccion> campaniaProgramaProduccionList=new ArrayList<CampaniaProgramaProduccion>();
    private List<ProgramaProduccionPeriodo> programaProduccionPeriodoList=new ArrayList<ProgramaProduccionPeriodo>();
    private ProgramaProduccionPeriodo programaProduccionPeriodoBean=null;
    private List<SelectItem> tiposCampaniaProgramaProduccionSelectList=new ArrayList<SelectItem>();
    private HtmlDataTable programaProduccionPeriodoDataTable=new HtmlDataTable();
    private CampaniaProgramaProduccion campaniaProgramaProduccionBean=new CampaniaProgramaProduccion();
    private List<CampaniaProgramaProduccionDetalle> campaniaProgramaProduccionDetalleList=new ArrayList<CampaniaProgramaProduccionDetalle>();
    private List<SelectItem> componentesProdSelectList=new ArrayList<SelectItem>();
    private String mensaje="";
    public ManagedCampanasProgramaProduccion() {
    }
    private void cargarComponentesProdSelect()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cp.COD_COMPPROD, cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where cp.COD_COMPPROD in"+
                               " ( select p.COD_COMPPROD from PROGRAMA_PRODUCCION p where p.COD_PROGRAMA_PROD='"+programaProduccionPeriodoBean.getCodProgramaProduccion()+"'"+
                               ") order by cp.nombre_prod_semiterminado";
            ResultSet res = st.executeQuery(consulta);
            componentesProdSelectList.clear();
            while (res.next())
            {
                componentesProdSelectList.add(new SelectItem(res.getString("COD_COMPPROD"),res.getString("nombre_prod_semiterminado")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarTiposCampaniaProgramaProduccionSelect()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select tcpp.COD_TIPO_CAMPANIA_PROGRAMA_PRODUCCION,tcpp.NOMBRE_TIPO_CAMPANIA_PROGRAMA_PRODUCCION"+
                              " from TIPOS_CAMPANIA_PROGRAMA_PRODUCCION tcpp order by tcpp.NOMBRE_TIPO_CAMPANIA_PROGRAMA_PRODUCCION";
            ResultSet res = st.executeQuery(consulta);
            tiposCampaniaProgramaProduccionSelectList.clear();
            while (res.next())
            {
                tiposCampaniaProgramaProduccionSelectList.add(new SelectItem(res.getInt("COD_TIPO_CAMPANIA_PROGRAMA_PRODUCCION"),res.getString("NOMBRE_TIPO_CAMPANIA_PROGRAMA_PRODUCCION")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarProgramaProduccionPeriodo()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES,(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA) NOMBRE_ESTADO_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and pp.cod_tipo_produccion=1 and isnull(PP.COD_TIPO_PRODUCCION,1) in(1,2)";
            ResultSet res = st.executeQuery(consulta);
            programaProduccionPeriodoList.clear();
            while (res.next())
            {
                ProgramaProduccionPeriodo nuevo=new ProgramaProduccionPeriodo();
                nuevo.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.setObsProgramaProduccion(res.getString("OBSERVACIONES"));
                programaProduccionPeriodoList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String getCargarProgramaProduccionPeriodo()
    {
        this.cargarProgramaProduccionPeriodo();
        return null;
    }
    public String seleccionarProgramaProduccionPeriodo()
    {
        programaProduccionPeriodoBean=(ProgramaProduccionPeriodo)programaProduccionPeriodoDataTable.getRowData();
        return null;
    }
    public String getCargarCampaniasProgramaProduccion()
    {
        this.cargarCampanasProgramaProduccion();
        this.cargarTiposCampaniaProgramaProduccionSelect();
        this.cargarComponentesProdSelect();
        
        return null;
    }
    public String buscarLotesProgramaProduccionProducto_action()
    {
        this.cargarLotesProgramaProduccion();
        return null;
    }
    private void cargarCampanasProgramaProduccion()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,"+
                              " cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION,cpp.NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION" +
                              " ,cpp.COD_COMPPROD,cp.nombre_prod_semiterminado,tcpp.COD_TIPO_CAMPANIA_PROGRAMA_PRODUCCION,"+
                              " tcpp.NOMBRE_TIPO_CAMPANIA_PROGRAMA_PRODUCCION" +
                              " ,pp.COD_LOTE_PRODUCCION,pp.CANT_LOTE_PRODUCCION,cp1.nombre_prod_semiterminado as productoLOte,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                              " from CAMPANIA_PROGRAMA_PRODUCCION cpp inner join PROGRAMA_PRODUCCION_PERIODO ppp  on"+
                              " cpp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD" +
                              " left outer join COMPONENTES_PROD cp on cp.COD_COMPPROD=cpp.COD_COMPPROD"+
                              " inner join TIPOS_CAMPANIA_PROGRAMA_PRODUCCION tcpp on"+
                              " tcpp.COD_TIPO_CAMPANIA_PROGRAMA_PRODUCCION=cpp.COD_TIPO_CAMPANIA_PROGRAMA_PRODUCCION"+
                              " inner join CAMPANIA_PROGRAMA_PRODUCCION_DETALLE cppd on cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION"+
                              " =cppd.COD_CAMPANIA_PROGRAMA_PRODUCCION"+
                              " inner join PROGRAMA_PRODUCCION pp on cppd.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                              " and cppd.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and"+
                              " cppd.COD_COMPPROD=pp.COD_COMPPROD"+
                              " and cppd.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                              " and pp.COD_PROGRAMA_PROD=cpp.COD_PROGRAMA_PROD" +
                              " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD"+
                              " =pp.COD_TIPO_PROGRAMA_PROD"+
                              " inner join COMPONENTES_PROD cp1 on cp1.COD_COMPPROD=pp.COD_COMPPROD"+
                              " where cpp.COD_PROGRAMA_PROD='"+programaProduccionPeriodoBean.getCodProgramaProduccion()+"'"+
                              " order by cpp.NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION";
            System.out.println("consulta cargar campanias "+consulta);
            ResultSet res = st.executeQuery(consulta);
            campaniaProgramaProduccionList.clear();
            CampaniaProgramaProduccion nuevo=new CampaniaProgramaProduccion();
            List<CampaniaProgramaProduccionDetalle> campaniaProgramaProduccionDetalles=new ArrayList<CampaniaProgramaProduccionDetalle>();
            while (res.next())
            {
                if(nuevo.getCodCampaniaProgramaProduccion()!=res.getInt("COD_CAMPANIA_PROGRAMA_PRODUCCION"))
                {
                    if(nuevo.getCodCampaniaProgramaProduccion()>0)
                    {
                        nuevo.setCampaniaProgramaProduccionDetalleList(campaniaProgramaProduccionDetalles);
                        campaniaProgramaProduccionList.add(nuevo);
                    }
                    nuevo=new CampaniaProgramaProduccion();
                    nuevo.setCodCampaniaProgramaProduccion(res.getInt("COD_CAMPANIA_PROGRAMA_PRODUCCION"));
                    nuevo.setNombreCampaniaProgramaProduccion(res.getString("NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION"));
                    nuevo.getTiposCampaniaProgramaProduccion().setCodTipoCampaniaProgramaProduccion(res.getInt("COD_TIPO_CAMPANIA_PROGRAMA_PRODUCCION"));
                    nuevo.getTiposCampaniaProgramaProduccion().setNombreTipoCampaniaProgramaProduccion(res.getString("NOMBRE_TIPO_CAMPANIA_PROGRAMA_PRODUCCION"));
                    nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                    nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    campaniaProgramaProduccionDetalles=new ArrayList<CampaniaProgramaProduccionDetalle>();
                }
                CampaniaProgramaProduccionDetalle bean=new CampaniaProgramaProduccionDetalle();
                bean.getProgramaProduccion().setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                bean.getProgramaProduccion().setCantidadLote(res.getDouble("CANT_LOTE_PRODUCCION"));
                bean.getProgramaProduccion().getComponentesProdVersion().setNombreProdSemiterminado(res.getString("productoLOte"));
                bean.getProgramaProduccion().getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));

                campaniaProgramaProduccionDetalles.add(bean);
            }
            if(nuevo.getCodCampaniaProgramaProduccion()>0)
            {
                nuevo.setCampaniaProgramaProduccionDetalleList(campaniaProgramaProduccionDetalles);
                campaniaProgramaProduccionList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String getCargarAgregarCampaniaProduccion()
    {
        campaniaProgramaProduccionBean=new CampaniaProgramaProduccion();
        campaniaProgramaProduccionBean.getComponentesProd().setCodCompprod("0");
        campaniaProgramaProduccionBean.getTiposCampaniaProgramaProduccion().setCodTipoCampaniaProgramaProduccion(2);
        this.cargarLotesProgramaProduccion();
        return null;
    }
    public String tipoCampania_change()
    {
        if(campaniaProgramaProduccionBean.getTiposCampaniaProgramaProduccion().getCodTipoCampaniaProgramaProduccion()!=1)
        {
            campaniaProgramaProduccionBean.getComponentesProd().setCodCompprod("0");
            this.cargarLotesProgramaProduccion();
        }
        return null;
    }
    private void cargarLotesProgramaProduccion()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select pp.COD_LOTE_PRODUCCION,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,"+
                               " tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_FORMULA_MAESTRA,"+
                               " isnull(cppd.COD_CAMPANIA_PROGRAMA_PRODUCCION,0) as registrado" +
                               " ,pp.CANT_LOTE_PRODUCCION"+
                               " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp"+
                               " on pp.COD_COMPPROD=cp.COD_COMPPROD"+
                               " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                               " left outer join CAMPANIA_PROGRAMA_PRODUCCION_DETALLE cppd on "+
                               " cppd.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and "+
                               " cppd.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and "+
                               " cppd.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD and "+
                               " cppd.COD_COMPPROD=pp.COD_COMPPROD"+
                               " and cppd.COD_CAMPANIA_PROGRAMA_PRODUCCION='"+campaniaProgramaProduccionBean.getCodCampaniaProgramaProduccion()+"'"+
                               " where pp.cod_estado_programa in (2,5,6,7) and  pp.COD_PROGRAMA_PROD='"+programaProduccionPeriodoBean.getCodProgramaProduccion()+"'"+
                               (campaniaProgramaProduccionBean.getTiposCampaniaProgramaProduccion().getCodTipoCampaniaProgramaProduccion()==1&&(!campaniaProgramaProduccionBean.getComponentesProd().getCodCompprod().equals("0"))?
                               " and cp.COD_COMPPROD='"+campaniaProgramaProduccionBean.getComponentesProd().getCodCompprod()+"'":"")+
                               " order by cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION";
            System.out.println("consulta cargar lotes produccion "+consulta);
            ResultSet res = st.executeQuery(consulta);
            campaniaProgramaProduccionDetalleList.clear();
            while (res.next())
            {
                CampaniaProgramaProduccionDetalle nuevo=new CampaniaProgramaProduccionDetalle();
                nuevo.getProgramaProduccion().setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                nuevo.getProgramaProduccion().getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.getProgramaProduccion().getComponentesProdVersion().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getProgramaProduccion().getComponentesProdVersion().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getProgramaProduccion().getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getProgramaProduccion().getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getProgramaProduccion().setCantidadLote(res.getDouble("CANT_LOTE_PRODUCCION"));
                nuevo.setChecked(res.getInt("registrado")>0);
                campaniaProgramaProduccionDetalleList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarCampaniaProgramaProduccion_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta = "select isnull(max(c.COD_CAMPANIA_PROGRAMA_PRODUCCION),0)+1 as codCampania"+
                              " from CAMPANIA_PROGRAMA_PRODUCCION c ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codCampania=0;
            if(res.next())codCampania=res.getInt("codCampania");
            consulta="INSERT INTO CAMPANIA_PROGRAMA_PRODUCCION(COD_CAMPANIA_PROGRAMA_PRODUCCION,"+
                     " NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION, COD_PROGRAMA_PROD, COD_COMPPROD,COD_TIPO_CAMPANIA_PROGRAMA_PRODUCCION)"+
                     " VALUES ('"+codCampania+"','"+campaniaProgramaProduccionBean.getNombreCampaniaProgramaProduccion()+"',"+
                     " '"+programaProduccionPeriodoBean.getCodProgramaProduccion()+"', '"+campaniaProgramaProduccionBean.getComponentesProd().getCodCompprod()+"'" +
                     ",'"+campaniaProgramaProduccionBean.getTiposCampaniaProgramaProduccion().getCodTipoCampaniaProgramaProduccion()+"')";
            System.out.println("consulta insertar campania "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la campania");
            int nroregistro=1;
            for(CampaniaProgramaProduccionDetalle bean:campaniaProgramaProduccionDetalleList)
            {
                if(bean.getChecked())
                {
                    
                    consulta="INSERT INTO CAMPANIA_PROGRAMA_PRODUCCION_DETALLE(COD_CAMPANIA_PROGRAMA_PRODUCCION, COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_COMPPROD,NRO_REGISTRO)"+
                             " VALUES ('"+codCampania+"','"+bean.getProgramaProduccion().getCodLoteProduccion()+"',"+
                             " '"+bean.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'," +
                             " '"+bean.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                             " '"+bean.getProgramaProduccion().getComponentesProdVersion().getCodCompprod()+"',"+
                             " '"+nroregistro+"')";
                    System.out.println("consulta insert campania detalle "+consulta);
                    pst = con.prepareStatement(consulta);
                    if (pst.executeUpdate() > 0)System.out.println("se registro el detalle");
                    nroregistro++;
                }

            }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            con.rollback();

            con.close();
            mensaje="Ocurrio un error al moment del registro, intente de nuevo";
            ex.printStackTrace();
        }
        return null;
    }
    public String eliminarCampaniaProgramaProduccion_action()throws SQLException
    {
        mensaje="";
        for(CampaniaProgramaProduccion bean:campaniaProgramaProduccionList)
        {
            if(bean.getChecked())
            {
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta = "DELETE CAMPANIA_PROGRAMA_PRODUCCION_DETALLE WHERE COD_CAMPANIA_PROGRAMA_PRODUCCION='"+bean.getCodCampaniaProgramaProduccion()+"'";
                    System.out.println("consulta delete campania DETALLE "+consulta);
                    PreparedStatement pst = con.prepareStatement(consulta);
                    if (pst.executeUpdate() > 0)System.out.println("se elimino el detalle");
                    consulta = "DELETE CAMPANIA_PROGRAMA_PRODUCCION WHERE COD_CAMPANIA_PROGRAMA_PRODUCCION='"+bean.getCodCampaniaProgramaProduccion()+"'";
                    System.out.println("consulta delete campania "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino la campania");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch (SQLException ex)
                {
                    con.rollback();
                    con.close();
                    mensaje="Ocurrio un error al momento de eliminar la campaña, intente de nuevo";
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarCampanasProgramaProduccion();
        }
        return null;
    }
    public String guardarEdicionCampaniaProgramaProduccion_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="UPDATE CAMPANIA_PROGRAMA_PRODUCCION set"+
                     " NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION ='"+campaniaProgramaProduccionBean.getNombreCampaniaProgramaProduccion()+"'" +
                     " ,COD_COMPPROD='"+campaniaProgramaProduccionBean.getComponentesProd().getCodCompprod()+"'" +
                     " ,COD_TIPO_CAMPANIA_PROGRAMA_PRODUCCION='"+campaniaProgramaProduccionBean.getTiposCampaniaProgramaProduccion().getCodTipoCampaniaProgramaProduccion()+"'"+
                     " WHERE COD_CAMPANIA_PROGRAMA_PRODUCCION='"+campaniaProgramaProduccionBean.getCodCampaniaProgramaProduccion()+"'";
            System.out.println("consulta update campania "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la campania");
            consulta="DELETE CAMPANIA_PROGRAMA_PRODUCCION_DETALLE WHERE COD_CAMPANIA_PROGRAMA_PRODUCCION='"+campaniaProgramaProduccionBean.getCodCampaniaProgramaProduccion()+"'";
            System.out.println("consulta delete detalle "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores");
            int nroRegistro=1;
            for(CampaniaProgramaProduccionDetalle bean:campaniaProgramaProduccionDetalleList)
            {
                if(bean.getChecked())
                {
                    consulta="INSERT INTO CAMPANIA_PROGRAMA_PRODUCCION_DETALLE(COD_CAMPANIA_PROGRAMA_PRODUCCION, COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,"+
                             " COD_TIPO_PROGRAMA_PROD, COD_COMPPROD,NRO_REGISTRO)"+
                             " VALUES ('"+campaniaProgramaProduccionBean.getCodCampaniaProgramaProduccion()+"','"+bean.getProgramaProduccion().getCodLoteProduccion()+"',"+
                             " '"+bean.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'," +
                             " '"+bean.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                             " '"+bean.getProgramaProduccion().getComponentesProdVersion().getCodCompprod()+"',"+
                             "'"+nroRegistro+"')";
                    System.out.println("consulta insert campania detalle "+consulta);
                    pst = con.prepareStatement(consulta);
                    if (pst.executeUpdate() > 0)System.out.println("se registro el detalle");
                    nroRegistro++;
                }

            }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch (SQLException ex)
        {
            con.rollback();

            con.close();
            mensaje="Ocurrio un error al moment del registro, intente de nuevo";
            ex.printStackTrace();
        }
        return null;
    }
    public String editarCampaniaProgramaProduccion_action()
    {
        for(CampaniaProgramaProduccion bean:campaniaProgramaProduccionList)
        {
            if(bean.getChecked())
            {
                campaniaProgramaProduccionBean=bean;
            }
        }
        this.cargarLotesProgramaProduccion();
        return null;
    }
    public CampaniaProgramaProduccion getCampaniaProgramaProduccionBean() {
        return campaniaProgramaProduccionBean;
    }

    public void setCampaniaProgramaProduccionBean(CampaniaProgramaProduccion campaniaProgramaProduccionBean) {
        this.campaniaProgramaProduccionBean = campaniaProgramaProduccionBean;
    }

    public List<CampaniaProgramaProduccionDetalle> getCampaniaProgramaProduccionDetalleList() {
        return campaniaProgramaProduccionDetalleList;
    }

    public void setCampaniaProgramaProduccionDetalleList(List<CampaniaProgramaProduccionDetalle> campaniaProgramaProduccionDetalleList) {
        this.campaniaProgramaProduccionDetalleList = campaniaProgramaProduccionDetalleList;
    }

    public List<CampaniaProgramaProduccion> getCampaniaProgramaProduccionList() {
        return campaniaProgramaProduccionList;
    }

    public void setCampaniaProgramaProduccionList(List<CampaniaProgramaProduccion> campaniaProgramaProduccionList) {
        this.campaniaProgramaProduccionList = campaniaProgramaProduccionList;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoBean() {
        return programaProduccionPeriodoBean;
    }

    public void setProgramaProduccionPeriodoBean(ProgramaProduccionPeriodo programaProduccionPeriodoBean) {
        this.programaProduccionPeriodoBean = programaProduccionPeriodoBean;
    }

    public HtmlDataTable getProgramaProduccionPeriodoDataTable() {
        return programaProduccionPeriodoDataTable;
    }

    public void setProgramaProduccionPeriodoDataTable(HtmlDataTable programaProduccionPeriodoDataTable) {
        this.programaProduccionPeriodoDataTable = programaProduccionPeriodoDataTable;
    }

    public List<ProgramaProduccionPeriodo> getProgramaProduccionPeriodoList() {
        return programaProduccionPeriodoList;
    }

    public void setProgramaProduccionPeriodoList(List<ProgramaProduccionPeriodo> programaProduccionPeriodoList) {
        this.programaProduccionPeriodoList = programaProduccionPeriodoList;
    }

    public List<SelectItem> getTiposCampaniaProgramaProduccionSelectList() {
        return tiposCampaniaProgramaProduccionSelectList;
    }

    public void setTiposCampaniaProgramaProduccionSelectList(List<SelectItem> tiposCampaniaProgramaProduccionSelectList) {
        this.tiposCampaniaProgramaProduccionSelectList = tiposCampaniaProgramaProduccionSelectList;
    }

    public List<SelectItem> getComponentesProdSelectList() {
        return componentesProdSelectList;
    }

    public void setComponentesProdSelectList(List<SelectItem> componentesProdSelectList) {
        this.componentesProdSelectList = componentesProdSelectList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    
}
