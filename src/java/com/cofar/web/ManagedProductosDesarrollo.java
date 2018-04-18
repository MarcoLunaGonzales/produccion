/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ComponentesProd;
import com.cofar.bean.ComponentesProdVersionMaquinariaProceso;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.dao.DaoEspecificacionesProcesosProductoMaquinaria;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;


/**
 *
 * @author DASISAQ-
 */

public class ManagedProductosDesarrollo extends ManagedBean{

    private List<ComponentesProd> componentesProdDesarrolloList=new ArrayList<ComponentesProd>();
    private ComponentesProd componentesProdNuevo=null;
    private ComponentesProd componentesProdEditar=null;
    private ComponentesProd componentesProdPresPrim=null;
    private ComponentesProd componentesProdBuscar=new ComponentesProd();
    private List<SelectItem> areasEmpresaSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> saboresSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> coloresPresPrimList=new ArrayList<SelectItem>();
    private List<SelectItem> formasFarmaceuticasSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> viasAdministracionSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> unidadesMedidaSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> productosSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> envasesPrimariosSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> tiposProgramaProdSelectList=new ArrayList<SelectItem>();
    private List<PresentacionesPrimarias> presentacionesPrimariasList=null;
    private HtmlDataTable htmlDataTableProductos=new HtmlDataTable();
    private PresentacionesPrimarias presentacionesPrimariaNuevo=new PresentacionesPrimarias();
    private PresentacionesPrimarias presentacionesPrimariaEditar=new PresentacionesPrimarias();
    private String mensaje="";
    private Connection con =null;
    /** Creates a new instance of ManagedProductosDesarrollo */
    public ManagedProductosDesarrollo(){
    }
    
    
    
    public String buscarComponentesProdDesarollo_action(){
        this.cargarComponentesProdDesarrollo();
        return null;
    }
    public String getCargarComponentesProdDesarrollo()
    {
        
        this.cargarProductosSelect();
        this.cargarColoresPresPrimariasSelect();
        this.cargarSaboresProductoSelect();
        this.cargarViasAdministracionSelect();
        this.cargarAreasEmpresaSelect();
        this.cargarFormasFarmaceuticasSelect();
        this.cargarComponentesProdDesarrollo();
        return null;
    }
    public String getCargarPresentacionesPrimarias()
    {
        this.cargarPresentacionesPrimarias();
        this.cargarEnvasesPrimariosSelect();
        this.cargarTiposProgramProdSelect();
        return null;
    }
    public String editarPresentacionPrimaria_action()
    {
        for(PresentacionesPrimarias bean:presentacionesPrimariasList)
        {
            if(bean.getChecked())
            {
                presentacionesPrimariaEditar=bean;
            }
        }
        return null;
    }
    private void cargarTiposProgramProdSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION tpp where tpp.COD_ESTADO_REGISTRO=1";
            ResultSet res=st.executeQuery(consulta);
            tiposProgramaProdSelectList.clear();
            while(res.next())
            {
                tiposProgramaProdSelectList.add(new SelectItem(res.getString("COD_TIPO_PROGRAMA_PROD"),res.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarEnvasesPrimariosSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ep.cod_envaseprim,ep.nombre_envaseprim from ENVASES_PRIMARIOS ep where ep.cod_estado_registro=1"+
                            " order by ep.nombre_envaseprim";
            ResultSet res=st.executeQuery(consulta);
            envasesPrimariosSelectList.clear();
            while(res.next())
            {
                envasesPrimariosSelectList.add(new SelectItem(res.getString("cod_envaseprim"),res.getString("nombre_envaseprim")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarFormasFarmaceuticasSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta="select  f.cod_forma,f.nombre_forma from FORMAS_FARMACEUTICAS f where f.cod_estado_registro=1 order by f.nombre_forma";
            ResultSet res=st.executeQuery(consulta);
            formasFarmaceuticasSelectList.clear();
            while(res.next())
            {
                formasFarmaceuticasSelectList.add(new SelectItem(res.getString("cod_forma"),res.getString("nombre_forma")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarColoresPresPrimariasSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select c.COD_COLORPRESPRIMARIA,c.NOMBRE_COLORPRESPRIMARIA "+
                            " from COLORES_PRESPRIMARIA c where c.COD_ESTADO_REGISTRO=1 order by c.NOMBRE_COLORPRESPRIMARIA";
            ResultSet res=st.executeQuery(consulta);
            coloresPresPrimList.clear();
            while(res.next())
            {
                coloresPresPrimList.add(new SelectItem(res.getString("COD_COLORPRESPRIMARIA"),res.getString("NOMBRE_COLORPRESPRIMARIA")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarProductosSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select p.cod_prod,p.nombre_prod from productos p where p.cod_estado_prod=1 order by p.nombre_prod";
            ResultSet res=st.executeQuery(consulta);
            productosSelectList.clear();
            while(res.next())
            {
                productosSelectList.add(new SelectItem(res.getString("cod_prod"),res.getString("nombre_prod")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarSaboresProductoSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select s.COD_SABOR,s.NOMBRE_SABOR from SABORES_PRODUCTO s where s.COD_ESTADO_REGISTRO=1"+
                            " order by s.NOMBRE_SABOR";
            ResultSet res=st.executeQuery(consulta);
            saboresSelectList.clear();
            while(res.next())
            {
                saboresSelectList.add(new SelectItem(res.getString("COD_SABOR"),res.getString("NOMBRE_SABOR")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarEdicionPresentacionPrimaria_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="update PRESENTACIONES_PRIMARIAS set COD_ENVASEPRIM='"+presentacionesPrimariaEditar.getEnvasesPrimarios().getCodEnvasePrim()+"',"+
                            " COD_TIPO_PROGRAMA_PROD='"+presentacionesPrimariaEditar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',"+
                            " CANTIDAD='"+presentacionesPrimariaEditar.getCantidad()+"',"+
                            " COD_ESTADO_REGISTRO='"+presentacionesPrimariaEditar.getEstadoReferencial().getCodEstadoRegistro()+"'"+
                            " where COD_PRESENTACION_PRIMARIA='"+presentacionesPrimariaEditar.getCodPresentacionPrimaria()+"'";
            System.out.println("consulta editar presentacion primaria "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se guardo la edicion");
            con.commit();
            pst.close();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion, intente de nuevo";
            ex.printStackTrace();
        }
        return null;
    }
    public String guardarNuevaPresentacionPrimaria_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="select isnull(max(pp.COD_PRESENTACION_PRIMARIA),0)+1 as codPresentacionPrimaria from PRESENTACIONES_PRIMARIAS pp";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codPresentacion=0;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            if(res.next())codPresentacion=res.getInt("codPresentacionPrimaria");
            consulta="INSERT INTO PRESENTACIONES_PRIMARIAS( COD_COMPPROD"+
                            " , COD_ENVASEPRIM, CANTIDAD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO,FECHA_MODIFICACION)"+
                            " VALUES ('"+componentesProdPresPrim.getCodCompprod()+"'," +
                            " '"+presentacionesPrimariaNuevo.getEnvasesPrimarios().getCodEnvasePrim()+"','"+presentacionesPrimariaNuevo.getCantidad()+"',"+
                            "'"+presentacionesPrimariaNuevo.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                            "1,'"+sdf.format(new Date())+"')";
            System.out.println("consulta insert presentacion primaria "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la presentacion primaria");
            con.commit();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de registrar la presentacion, intente de nuevo";
            ex.printStackTrace();
        }
        return null;
    }
    private void cargarPresentacionesPrimarias()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ep.cod_envaseprim,ep.nombre_envaseprim,pp.CANTIDAD,pp.cod_presentacion_primaria,"+
                            " tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_TIPO_PROGRAMA_PROD,er.NOMBRE_ESTADO_REGISTRO,pp.COD_ESTADO_REGISTRO,pp.COD_PRESENTACION_PRIMARIA"+
                            " from PRESENTACIONES_PRIMARIAS pp inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=pp.COD_ENVASEPRIM"+
                            " left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                            " left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=pp.COD_ESTADO_REGISTRO"+
                            " where pp.COD_COMPPROD='"+componentesProdPresPrim.getCodCompprod()+"'"+
                            " order by ep.nombre_envaseprim";
            System.out.println("consulta cargar presentaciones primarias "+consulta);
            ResultSet res=st.executeQuery(consulta);
            presentacionesPrimariasList=new ArrayList<PresentacionesPrimarias>();
            presentacionesPrimariasList.clear();
            while(res.next())
            {
                PresentacionesPrimarias nuevo=new PresentacionesPrimarias();
                nuevo.getEnvasesPrimarios().setCodEnvasePrim(res.getString("cod_envaseprim"));
                nuevo.getEnvasesPrimarios().setNombreEnvasePrim(res.getString("nombre_envaseprim"));
                nuevo.setCantidad(res.getInt("CANTIDAD"));
                nuevo.setCodPresentacionPrimaria(res.getString("cod_presentacion_primaria"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                presentacionesPrimariasList.add(nuevo);
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarViasAdministracionSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="SELECT vap.COD_VIA_ADMINISTRACION_PRODUCTO,vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO"+
                            " FROM VIAS_ADMINISTRACION_PRODUCTO vap where vap.COD_ESTADO_REGISTRO = 1"+
                            " order by vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO";
            ResultSet res=st.executeQuery(consulta);
            viasAdministracionSelectList.clear();
            while(res.next())
            {
                viasAdministracionSelectList.add(new SelectItem(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"),res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarUnidadesMedidadSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select um.COD_UNIDAD_MEDIDA,um.ABREVIATURA from UNIDADES_MEDIDA um where um.COD_ESTADO_REGISTRO=1"+
                            " order by um.ABREVIATURA";
            ResultSet res=st.executeQuery(consulta);
            unidadesMedidaSelectList.clear();
            while(res.next())unidadesMedidaSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("ABREVIATURA")));
            st.close();
            con.close();
            
        }
        catch(SQLException ex)
        {
                ex.printStackTrace();
        }
    }
    private void cargarAreasEmpresaSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA ae where ae.COD_AREA_EMPRESA in "+
                            " (80,81,82,95) order by ae.NOMBRE_AREA_EMPRESA";
            ResultSet res=st.executeQuery(consulta);
            areasEmpresaSelectList.clear();
            while(res.next())
            {
                areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarComponentesProdDesarrollo()
    {

        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,cp.NOMBRE_GENERICO,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA" +
                            " ,cp.CANTIDAD_VOLUMEN,isnull(cp.CONCENTRACION_ENVASE_PRIMARIO,'') as CONCENTRACION_ENVASE_PRIMARIO" +
                            ",isnull(sp.COD_SABOR,0) as codSabor,isnull(sp.NOMBRE_SABOR,'') as nombreSabor" +
                            " ,isnull(cpp.COD_COLORPRESPRIMARIA,0) as codColorPresPrimaria,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as nombrePresentacionPrimaria" +
                            " ,cp.PESO_ENVASE_PRIMARIO,isnull(vap.COD_VIA_ADMINISTRACION_PRODUCTO,0) as codViaAdministracion,isnull(vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,'') as nombreViaAdministracion" +
                            " ,isnull(f.cod_forma,0) as codForma,isnull(f.nombre_forma,'') as nombreForma" +
                            " ,p.cod_prod,isnull(p.nombre_prod,'') as nombreProd" +
                            " ,um.COD_UNIDAD_MEDIDA,isnull(um.ABREVIATURA,'') as ABREVIATURA,cp.PRODUCTO_SEMITERMINADO" +
                            " ,ec.COD_ESTADO_COMPPROD,isnull(ec.NOMBRE_ESTADO_COMPPROD,'') as nombreEstado"+
                            " from COMPONENTES_PROD cp inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA" +
                            " left outer join SABORES_PRODUCTO sp on sp.COD_SABOR=cp.COD_SABOR" +
                            " left outer join COLORES_PRESPRIMARIA cpp on cpp.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA"+
                            " left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cp.COD_VIA_ADMINISTRACION_PRODUCTO" +
                            " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA" +
                            " left outer join productos p on p.cod_prod=cp.COD_PROD"+
                            " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
                            " inner join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD=cp.COD_ESTADO_COMPPROD" +
                            " where cp.COD_TIPO_PRODUCCION=2"+
                            ((componentesProdBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0")||componentesProdBuscar.getAreasEmpresa().getCodAreaEmpresa().equals(""))?"":" and cp.COD_AREA_EMPRESA='"+componentesProdBuscar.getAreasEmpresa().getCodAreaEmpresa()+"'")+
                            ((componentesProdBuscar.getColoresPresentacion().getCodColor().equals("0")||componentesProdBuscar.getColoresPresentacion().getCodColor().equals(""))?"":" and cp.COD_COLORPRESPRIMARIA='"+componentesProdBuscar.getColoresPresentacion().getCodColor()+"'")+
                            ((componentesProdBuscar.getForma().getCodForma().equals("0")||componentesProdBuscar.getForma().getCodForma().equals(""))?"":" and cp.cod_forma='"+componentesProdBuscar.getForma().getCodForma()+"'")+
                            ((componentesProdBuscar.getSaboresProductos().getCodSabor().equals("0")||componentesProdBuscar.getSaboresProductos().getCodSabor().equals(""))?"":" and cp.COD_SABOR='"+componentesProdBuscar.getSaboresProductos().getCodSabor()+"'")+
                            ((componentesProdBuscar.getProducto().getCodProducto().equals("0")||componentesProdBuscar.getProducto().getCodProducto().equals(""))?"":" and cp.COD_PROD='"+componentesProdBuscar.getProducto().getCodProducto()+"'")+
                            ((componentesProdBuscar.getEstadoCompProd().getCodEstadoCompProd()==0)?"":" and cp.COD_ESTADO_COMPPROD='"+componentesProdBuscar.getEstadoCompProd().getCodEstadoCompProd()+"'")+
                            (componentesProdBuscar.getViasAdministracionProducto().getCodViaAdministracionProducto()>0?" and cp.COD_VIA_ADMINISTRACION_PRODUCTO='"+componentesProdBuscar.getViasAdministracionProducto().getCodViaAdministracionProducto()+"'":"")+
                            (componentesProdBuscar.getNombreProdSemiterminado().equals("")?"":" and cp.nombre_prod_semiterminado like '%"+componentesProdBuscar.getNombreProdSemiterminado()+"%'")+
                            (componentesProdBuscar.getNombreGenerico().equals("")?"":" and cp.NOMBRE_GENERICO like '%"+componentesProdBuscar.getNombreGenerico()+"%'")+
                            
                            " order by cp.nombre_prod_semiterminado";
            System.out.println("consulta cargar productos desarrollo "+consulta);
            ResultSet res=st.executeQuery(consulta);
            componentesProdDesarrolloList.clear();
            while(res.next())
            {
                ComponentesProd nuevo=new ComponentesProd();
                nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setNombreGenerico(res.getString("NOMBRE_GENERICO"));
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.getSaboresProductos().setCodSabor(res.getString("codSabor"));
                nuevo.getSaboresProductos().setNombreSabor(res.getString("nombreSabor"));
                nuevo.getColoresPresentacion().setCodColor(res.getString("codColorPresPrimaria"));
                nuevo.getColoresPresentacion().setNombreColor(res.getString("nombrePresentacionPrimaria"));
                nuevo.setCantidadVolumen(res.getDouble("CANTIDAD_VOLUMEN"));
                nuevo.getViasAdministracionProducto().setCodViaAdministracionProducto(res.getInt("codViaAdministracion"));
                nuevo.getViasAdministracionProducto().setNombreViaAdministracionProducto(res.getString("nombreViaAdministracion"));
                nuevo.getForma().setCodForma(res.getString("codForma"));
                nuevo.getForma().setNombreForma(res.getString("nombreForma"));
                nuevo.getProducto().setCodProducto(res.getString("cod_prod"));
                nuevo.getProducto().setNombreProducto(res.getString("nombreProd"));
                nuevo.setConcentracionEnvasePrimario(res.getString("CONCENTRACION_ENVASE_PRIMARIO"));
                nuevo.getUnidadMedidaVolumen().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                nuevo.getUnidadMedidaVolumen().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.setPesoEnvasePrimario(res.getString("PESO_ENVASE_PRIMARIO"));
                nuevo.setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO")>0);
                nuevo.getEstadoCompProd().setCodEstadoCompProd(res.getInt("COD_ESTADO_COMPPROD"));
                nuevo.getEstadoCompProd().setNombreEstadoCompProd(res.getString("nombreEstado"));
                componentesProdDesarrolloList.add(nuevo);
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarEdicionProductoDesarrollo_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="update COMPONENTES_PROD set NOMBRE_GENERICO='"+componentesProdEditar.getNombreGenerico()+"',"+
                            " nombre_prod_semiterminado='"+componentesProdEditar.getNombreProdSemiterminado()+"',"+
                            " CONCENTRACION_ENVASE_PRIMARIO='"+componentesProdEditar.getConcentracionEnvasePrimario()+"',"+
                            " CANTIDAD_VOLUMEN='"+componentesProdEditar.getCantidadVolumen()+"',"+
                            " COD_UNIDAD_MEDIDA_VOLUMEN='"+componentesProdEditar.getUnidadMedidaVolumen().getCodUnidadMedida()+"',"+
                            " PESO_ENVASE_PRIMARIO='"+componentesProdEditar.getPesoEnvasePrimario()+"',"+
                            " COD_PROD='"+componentesProdEditar.getProducto().getCodProducto()+"',"+
                            " COD_FORMA='"+componentesProdEditar.getForma().getCodForma()+"',"+
                            " COD_COLORPRESPRIMARIA='"+componentesProdEditar.getColoresPresentacion().getCodColor()+"',"+
                            " COD_SABOR='"+componentesProdEditar.getSaboresProductos().getCodSabor()+"',"+
                            " COD_VIA_ADMINISTRACION_PRODUCTO='"+componentesProdEditar.getViasAdministracionProducto().getCodViaAdministracionProducto()+"',"+
                            " COD_AREA_EMPRESA='"+componentesProdEditar.getAreasEmpresa().getCodAreaEmpresa()+"',"+
                            " PRODUCTO_SEMITERMINADO='"+(componentesProdEditar.isProductoSemiterminado()?1:0)+"',"+
                            " COD_ESTADO_COMPPROD='"+componentesProdEditar.getEstadoCompProd().getCodEstadoCompProd()+"'"+
                            " where COD_COMPPROD='"+componentesProdEditar.getCodCompprod()+"'";
            System.out.println("consulta guardar edicion "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se guardo la edicion");
            
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        return null;
    }
    public String getCargarAgregarPresentacionPrimaria()
    {
        presentacionesPrimariaNuevo=new PresentacionesPrimarias();
        return null;
    }
    public String getCargarAgregarProductoDesarrollo_action()
    {
        componentesProdNuevo=new ComponentesProd();
        this.cargarAreasEmpresaSelect();
        this.cargarColoresPresPrimariasSelect();
        this.cargarSaboresProductoSelect();
        this.cargarFormasFarmaceuticasSelect();
        this.cargarViasAdministracionSelect();
        this.cargarUnidadesMedidadSelect();
        this.cargarProductosSelect();
        return null;
    }

    public String guardarNuevoProductoDesarrollo_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="select isnull(max(cp.COD_COMPPROD),0)+1 as codP from COMPONENTES_PROD cp";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codProducto=0;
            if(res.next())codProducto=res.getInt("codP");
            consulta="INSERT INTO COMPONENTES_PROD(COD_PROD, COD_FORMA,"+
                            " COD_ENVASEPRIM, COD_COLORPRESPRIMARIA, VOLUMENPESO_ENVASEPRIM, CANTIDAD_COMPPROD"+
                            " , COD_AREA_EMPRESA, COD_SABOR, volumenpeso_aproximado, COD_COMPUESTOPROD,"+
                            " nombre_prod_semiterminado, NOMBRE_GENERICO, REG_SANITARIO, COD_LINEAMKT,"+
                            " COD_CATEGORIACOMPPROD, VIDA_UTIL, FECHA_VENCIMIENTO_RS, COD_ESTADO_COMPPROD,"+
                            " RENDIMIENTO_PRODUCTO, COD_TIPO_PRODUCCION, VOLUMEN_ENVASE_PRIMARIO,"+
                            " CONCENTRACION_ENVASE_PRIMARIO, PESO_ENVASE_PRIMARIO,"+
                            " DIRECCION_ARCHIVO_REGISTRO_SANITARIO, COD_VIA_ADMINISTRACION_PRODUCTO,"+
                            " CANTIDAD_VOLUMEN, COD_UNIDAD_MEDIDA_VOLUMEN, TOLERANCIA_VOLUMEN_FABRICAR,"+
                            " COD_TIPO_COMPPROD_FORMATO, COD_TIPO_CLASIFICACION_PRODUCTO,PRODUCTO_SEMITERMINADO)"+
                            " VALUES ('"+componentesProdNuevo.getProducto().getCodProducto()+"'," +
                            " '"+componentesProdNuevo.getForma().getCodForma()+"',0,"+
                            "'"+componentesProdNuevo.getColoresPresentacion().getCodColor()+"'," +
                            "'"+componentesProdNuevo.getVolumenEnvasePrimario()+"',0,"+
                            " '"+componentesProdNuevo.getAreasEmpresa().getCodAreaEmpresa()+"','"+componentesProdNuevo.getSaboresProductos().getCodSabor()+"'," +
                            " 0, 0,'"+componentesProdNuevo.getNombreProdSemiterminado()+"', '"+componentesProdNuevo.getNombreGenerico()+"'," +
                            "'','','', 0,null, 1,0,2,'"+componentesProdNuevo.getVolumenEnvasePrimario()+"'," +
                            "'"+componentesProdNuevo.getConcentracionEnvasePrimario()+"', '"+componentesProdNuevo.getPesoEnvasePrimario()+"',"+
                            "'','"+componentesProdNuevo.getViasAdministracionProducto().getCodViaAdministracionProducto()+"',"+
                            " '"+componentesProdNuevo.getCantidadVolumen()+"','"+componentesProdNuevo.getUnidadMedidaVolumen().getCodUnidadMedida()+"'," +
                            " 0,0,0,'"+(componentesProdNuevo.isProductoSemiterminado()?1:0)+"')";
            System.out.println("consulta insert producto desarrollo "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el producto");
            con.commit();
            mensaje="1";
            pst.close();
            res.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
            mensaje="Ocurrio un error al momento de registrar el producto, intente de nuevo";
            con.rollback();
            con.close();
        }
        return null;
    }
    public String editarProductoDesarrollo_action()
    {
        for(ComponentesProd bean:componentesProdDesarrolloList)
        {
            if(bean.getChecked())
            {
                componentesProdEditar=bean;
            }
        }
        return null;
    }
    public String seleccionProducionPresentacionPrimaria_action()
    {
        componentesProdPresPrim=(ComponentesProd)htmlDataTableProductos.getRowData();
        return null;
    }
    public List<SelectItem> getAreasEmpresaSelectList() {
        return areasEmpresaSelectList;
    }

    public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
        this.areasEmpresaSelectList = areasEmpresaSelectList;
    }

    public List<SelectItem> getColoresPresPrimList() {
        return coloresPresPrimList;
    }

    public void setColoresPresPrimList(List<SelectItem> coloresPresPrimList) {
        this.coloresPresPrimList = coloresPresPrimList;
    }

    public List<ComponentesProd> getComponentesProdDesarrolloList() {
        return componentesProdDesarrolloList;
    }

    public void setComponentesProdDesarrolloList(List<ComponentesProd> componentesProdDesarrolloList) {
        this.componentesProdDesarrolloList = componentesProdDesarrolloList;
    }

    public ComponentesProd getComponentesProdEditar() {
        return componentesProdEditar;
    }

    public void setComponentesProdEditar(ComponentesProd componentesProdEditar) {
        this.componentesProdEditar = componentesProdEditar;
    }

    public ComponentesProd getComponentesProdNuevo() {
        return componentesProdNuevo;
    }

    public void setComponentesProdNuevo(ComponentesProd componentesProdNuevo) {
        this.componentesProdNuevo = componentesProdNuevo;
    }

    public List<SelectItem> getSaboresSelectList() {
        return saboresSelectList;
    }

    public void setSaboresSelectList(List<SelectItem> saboresSelectList) {
        this.saboresSelectList = saboresSelectList;
    }

    public List<SelectItem> getFormasFarmaceuticasSelectList() {
        return formasFarmaceuticasSelectList;
    }

    public void setFormasFarmaceuticasSelectList(List<SelectItem> formasFarmaceuticasSelectList) {
        this.formasFarmaceuticasSelectList = formasFarmaceuticasSelectList;
    }

    public List<SelectItem> getViasAdministracionSelectList() {
        return viasAdministracionSelectList;
    }

    public void setViasAdministracionSelectList(List<SelectItem> viasAdministracionSelectList) {
        this.viasAdministracionSelectList = viasAdministracionSelectList;
    }

    public List<SelectItem> getProductosSelectList() {
        return productosSelectList;
    }

    public void setProductosSelectList(List<SelectItem> productosSelectList) {
        this.productosSelectList = productosSelectList;
    }

    public List<SelectItem> getUnidadesMedidaSelectList() {
        return unidadesMedidaSelectList;
    }

    public void setUnidadesMedidaSelectList(List<SelectItem> unidadesMedidaSelectList) {
        this.unidadesMedidaSelectList = unidadesMedidaSelectList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public ComponentesProd getComponentesProdPresPrim() {
        return componentesProdPresPrim;
    }

    public void setComponentesProdPresPrim(ComponentesProd componentesProdPresPrim) {
        this.componentesProdPresPrim = componentesProdPresPrim;
    }

    public HtmlDataTable getHtmlDataTableProductos() {
        return htmlDataTableProductos;
    }

    public void setHtmlDataTableProductos(HtmlDataTable htmlDataTableProductos) {
        this.htmlDataTableProductos = htmlDataTableProductos;
    }

    public List<SelectItem> getEnvasesPrimariosSelectList() {
        return envasesPrimariosSelectList;
    }

    public void setEnvasesPrimariosSelectList(List<SelectItem> envasesPrimariosSelectList) {
        this.envasesPrimariosSelectList = envasesPrimariosSelectList;
    }

    public List<PresentacionesPrimarias> getPresentacionesPrimariasList() {
        return presentacionesPrimariasList;
    }

    public void setPresentacionesPrimariasList(List<PresentacionesPrimarias> presentacionesPrimariasList) {
        this.presentacionesPrimariasList = presentacionesPrimariasList;
    }

    public PresentacionesPrimarias getPresentacionesPrimariaEditar() {
        return presentacionesPrimariaEditar;
    }

    public void setPresentacionesPrimariaEditar(PresentacionesPrimarias presentacionesPrimariaEditar) {
        this.presentacionesPrimariaEditar = presentacionesPrimariaEditar;
    }

    public PresentacionesPrimarias getPresentacionesPrimariaNuevo() {
        return presentacionesPrimariaNuevo;
    }

    public void setPresentacionesPrimariaNuevo(PresentacionesPrimarias presentacionesPrimariaNuevo) {
        this.presentacionesPrimariaNuevo = presentacionesPrimariaNuevo;
    }

    public List<SelectItem> getTiposProgramaProdSelectList() {
        return tiposProgramaProdSelectList;
    }

    public void setTiposProgramaProdSelectList(List<SelectItem> tiposProgramaProdSelectList) {
        this.tiposProgramaProdSelectList = tiposProgramaProdSelectList;
    }

    public ComponentesProd getComponentesProdBuscar() {
        return componentesProdBuscar;
    }

    public void setComponentesProdBuscar(ComponentesProd componentesProdBuscar) {
        this.componentesProdBuscar = componentesProdBuscar;
    }

    


}
