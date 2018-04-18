/*
 * ManagedPresentacionesProducto.java
 *
 *
 */

package com.cofar.web;

import com.cofar.bean.PresentacionesProducto;
import com.cofar.bean.ComponentesProd;
import com.cofar.bean.util.correos.EnvioCorreoCreacionPresentacion;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.component.html.HtmlSelectOneMenu;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.ResultDataModel;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;


/**
 *
 * Autor Guery Garcia Jaldin 
 * 29/9/2010
 */
public class ManagedPresentacionesProducto extends ManagedBean{
    
    /** Creates a new instance of ManagedPersonal */
    //public static Logger logger=Logger.getLogger(ManagedPresentacionesProducto.class);
    private Connection con=null;
    private List<PresentacionesProducto> presentacionesProductoList=new ArrayList<PresentacionesProducto>();
    private List presentacionesProductoEli=new ArrayList();
    private List presentacionesProductoEli2=new ArrayList();
    private PresentacionesProducto presentacionesProductoAgregar=new PresentacionesProducto();
    private ComponentesProd componentesProd=new ComponentesProd();
    private List estadoRegistro=new  ArrayList();
    private List<SelectItem> productosSelectList=new  ArrayList<SelectItem>();
    private List<SelectItem> tiposMercaderiaSelectList=new  ArrayList<SelectItem>();
    private List<SelectItem> envasesSecundariosSelectList=new  ArrayList<SelectItem>();
    private List<SelectItem> lineasMKTSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> tiposPresentacionSelecList=new  ArrayList<SelectItem>();
    private String codigo="";
    private ResultDataModel componentesList;
    //*datos de los componentes
    private List<ComponentesProd> listaComponentesBuscar=new ArrayList<ComponentesProd>();
    private List<ComponentesProd> listaComponentesSeleccionados=new ArrayList<ComponentesProd>();
    private List listaComponentesLista=new ArrayList();
    private List eliminaComponentesSeleccionados=new ArrayList();
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    private String principioActivo="";
    private List componentespresentaciones=new ArrayList();
    private ComponentesProd editarComponente = new ComponentesProd();
    private HtmlDataTable componentesSeleccionadosDataTable =new HtmlDataTable();
    private List componenteEditarList=new ArrayList();
    private String editarCodCompprod="";
    private String editarNombreProdSemiterminado="";
    private String editarCantidadCompprod="";
    private HtmlDataTable componentesBuscarDataTable =new HtmlDataTable();
    private List<SelectItem> categoriaProductoSelectList = new ArrayList<SelectItem>();
    private HtmlSelectOneMenu componentesEditarSelectOneMenu = new HtmlSelectOneMenu();
    private List<SelectItem> tiposProgramaProduccionSelectList = new ArrayList<SelectItem>();
    private String mensaje="";
    private PresentacionesProducto presentacionesProductoEditar=null;
    private PresentacionesProducto presentacionesProductoBuscar=new PresentacionesProducto();
    private List<SelectItem> estadosPresentacionesProductoSelectList;
    
    

    
    
    public ManagedPresentacionesProducto()
    {
        LOGGER=LogManager.getLogger("PresentacionesProducto");
        begin=0;
        end=20;
        numrows=20;
        presentacionesProductoBuscar.getProducto().setCodProducto("0");
        presentacionesProductoBuscar.getTiposMercaderia().setCodTipoMercaderia("0");
        presentacionesProductoBuscar.getLineaMKT().setCodLineaMKT("0");
        presentacionesProductoBuscar.getTiposProgramaProduccion().setCodTipoProgramaProd("0");
        presentacionesProductoBuscar.getEstadoReferencial().setCodEstadoRegistro("1");
    }
  
    
    public String getObtenerCodigo(){
        String cod=Util.getParameter("codigo");
        LOGGER.info("CodProd :"+cod);
        if(cod!=null){
            setCodigo(cod);
        }
        // cargarProdFormasFar();
        return "";
    }
    private void cargarTiposPresentacionSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select TP.COD_TIPO_PRESENTACION, TP.NOMBRE_TIPO_PRESENTACION from TIPOS_PRESENTACION TP ";
            ResultSet res = st.executeQuery(consulta);
            tiposPresentacionSelecList.clear();
            while (res.next())
            {
                tiposPresentacionSelecList.add(new SelectItem(res.getString("COD_TIPO_PRESENTACION"),res.getString("NOMBRE_TIPO_PRESENTACION")));
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    public String cargarNombrePresentacion(String cod){
        String nombre="";
        String sql_aux = "";
        try{
            sql_aux=" select (select sp.nombre_sabor from SABORES_PRODUCTO sp where sp.COD_SABOR =cp.COD_SABOR and cp.cod_sabor<>0) as nombreSabor,";
            sql_aux+=" cp.VOLUMENPESO_ENVASEPRIM,";
            sql_aux+=" (select es.NOMBRE_ENVASESEC from ENVASES_SECUNDARIOS es where es.COD_ENVASESEC = pp.COD_ENVASESEC) as nombreEnvaseSec,";
            sql_aux+=" pp.cantidad_presentacion,";
            sql_aux+=" (select ff.nombre_forma from FORMAS_FARMACEUTICAS ff where ff.cod_forma= cp.cod_forma) as nombreForma ";            
            sql_aux+=" from COMPONENTES_PROD cp, COMPONENTES_PRESPROD cpp, PRESENTACIONES_PRODUCTO pp";
            sql_aux+=" where cp.COD_COMPPROD = cpp.COD_COMPPROD";
            sql_aux+=" and cpp.COD_PRESENTACION = pp.cod_presentacion";            
            sql_aux+=" and pp.cod_presentacion='"+cod+"'";
            
            LOGGER.debug("PresentacionesProducto:sql:"+sql_aux);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql_aux);
            while (rs.next()){                
                String aux=rs.getString(1);
                LOGGER.info("aux:"+aux);
                if(aux!=null){
                    nombre+=aux+" ";
                }
                nombre+=rs.getString(2)+" "+rs.getString(3)+" x "+rs.getString(4)+" "+rs.getString(5);
            }
            if(rs!=null){
                rs.close();
                st.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nombre;
    }
    
    public String obtenerFormaFarmaceutica(String codprod) throws SQLException{
        String sql=" select ff.nombre_forma from FORMAS_FARMACEUTICAS ff,COMPONENTES_PROD cp where ff.cod_forma= cp.cod_forma and cod_prod="+codprod;
        Statement st=con.createStatement();
        ResultSet rs=st.executeQuery(sql);
        String nombre_forma="";
        while (rs.next())
            nombre_forma+=rs.getString(1)+" ";
        rs.close();
        st.close();
        return nombre_forma;
    }
    
    
    public String obtenerSabor(String codprod) throws SQLException{
        String sql=" select sp.nombre_sabor from SABORES_PRODUCTO sp,COMPONENTES_PROD cp where sp.COD_SABOR =cp.COD_SABOR and cod_prod="+codprod;
        Statement st=con.createStatement();
        ResultSet rs=st.executeQuery(sql);
        String nombre_sabor="";
        while (rs.next())
            nombre_sabor+=rs.getString(1)+" ";
        rs.close();
        st.close();
        return nombre_sabor;
    }
    
    public String obtenerNombreColorpresprimaria(String codprod) throws SQLException{
        String sql="select cp1.nombre_colorpresprimaria from COLORES_PRESPRIMARIA cp1,COMPONENTES_PROD cp  where cp1.COD_COLORPRESPRIMARIA = cp.COD_COLORPRESPRIMARIA and cod_prod="+codprod;
        Statement st=con.createStatement();
        ResultSet rs=st.executeQuery(sql);
        String nombre_colorpresprimaria="";
        while (rs.next())
            nombre_colorpresprimaria+=rs.getString(1)+" ";
        rs.close();
        st.close();
        return nombre_colorpresprimaria;
    }
    
    public String obtenerNombreEnvaseprim(String codprod) throws SQLException{
        String sql="select ep.nombre_envaseprim from ENVASES_PRIMARIOS ep, COMPONENTES_PROD cp where  ep.cod_envaseprim = cp.cod_envaseprim and cod_prod="+codprod;
        Statement st=con.createStatement();
        ResultSet rs=st.executeQuery(sql);
        String nombre_envaseprim="";
        while (rs.next())
            nombre_envaseprim+=rs.getString(1)+" ";
        rs.close();
        st.close();
        return nombre_envaseprim; 
    }
    public String seleccionarPresentacionCambioEstado_action()throws SQLException
    {
        for(PresentacionesProducto bean:presentacionesProductoList)
        {
            if(bean.getChecked())
            {
                presentacionesProductoEditar=bean;
            }
        }
        return null;
    }
    private  void cargarPresentacionesProductoList()
    {
        try {
            String consulta=" select * from ( select ROW_NUMBER() over (order by nombre_producto_presentacion ASC) as 'FILAS', ppr.cod_prod,p.nombre_prod," +
                        " ppr.COD_PRESENTACION, ppr.cant_envase_secundario, ppr.COD_ENVASESEC, ppr.COD_ENVASETERCIARIO, ppr.COD_LINEAMKT,  ppr.cantidad_presentacion, ppr.cod_tipomercaderia," +
                        " ppr.COD_CARTON,   ppr.OBS_PRESENTACION,  ppr.cod_estado_registro, ppr.cod_anterior,lmkt.NOMBRE_LINEAMKT,tm.nombre_tipomercaderia,c.NOMBRE_CARTON,e.NOMBRE_ESTADO_PRESENTACION_PRODUCTO as NOMBRE_ESTADO_REGISTRO" +
                        " ,ppr.nombre_producto_presentacion ,ppr.cod_tipo_presentacion,ppr.cod_categoria ,tppr.cod_tipo_programa_prod,tppr.nombre_tipo_programa_prod " +
                        " ,isnull(es.NOMBRE_ENVASESEC,'') as NOMBRE_ENVASESEC,ISNULL(cp.NOMBRE_CATEGORIA,'') as NOMBRE_CATEGORIA" +
                        " from PRESENTACIONES_PRODUCTO ppr left outer join productos p on p.cod_prod = ppr.cod_prod " +
                        " left outer join lineas_mkt lmkt on lmkt.COD_LINEAMKT = ppr.COD_LINEAMKT " +
                        " left outer join TIPOS_MERCADERIA tm on tm.cod_tipomercaderia = ppr.cod_tipomercaderia " +
                        " left outer join CARTONES_CORRUGADOS c on c.COD_CARTON = ppr.COD_CARTON " +
                        " left outer join ESTADOS_PRESENTACIONES_PRODUCTO e on e.COD_ESTADO_PRESENTACION_PRODUCTO = ppr.cod_estado_registro" +
                        " left outer join tipos_programa_produccion  tppr on tppr.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod " +
                        " left outer join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC=ppr.COD_ENVASESEC" +
                        " left outer join CATEGORIAS_PRODUCTO cp on cp.COD_CATEGORIA=ppr.COD_CATEGORIA" +
                        " where lmkt.cod_estado_registro=1 " +
                        (presentacionesProductoBuscar.getNombreProductoPresentacion().equals("")?"":" and ppr.NOMBRE_PRODUCTO_PRESENTACION like '%"+presentacionesProductoBuscar.getNombreProductoPresentacion()+"%'")+
                        (presentacionesProductoBuscar.getCodAnterior().equals("")?"":" and ppr.cod_anterior like '%"+presentacionesProductoBuscar.getCodAnterior()+"%'")+
                        (presentacionesProductoBuscar.getCantidadPresentacion().equals("")?"":" and ppr.cantidad_presentacion='"+presentacionesProductoBuscar.getCantidadPresentacion()+"'")+
                        (presentacionesProductoBuscar.getProducto().getCodProducto().equals("0")?"":" and ppr.cod_prod='"+presentacionesProductoBuscar.getProducto().getCodProducto()+"'")+
                        (presentacionesProductoBuscar.getTiposMercaderia().getCodTipoMercaderia().equals("0")?"":" and ppr.cod_tipomercaderia='"+presentacionesProductoBuscar.getTiposMercaderia().getCodTipoMercaderia()+"'")+
                        (presentacionesProductoBuscar.getLineaMKT().getCodLineaMKT().equals("0")?"":" and ppr.COD_LINEAMKT='"+presentacionesProductoBuscar.getLineaMKT().getCodLineaMKT()+"'")+
                        (presentacionesProductoBuscar.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("0")?"":" and ppr.COD_TIPO_PROGRAMA_PROD='"+presentacionesProductoBuscar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'")+
                        (presentacionesProductoBuscar.getEstadoReferencial().getCodEstadoRegistro().equals("0")?"":" and ppr.cod_estado_registro='"+presentacionesProductoBuscar.getEstadoReferencial().getCodEstadoRegistro()+"'")+
                        " ) AS PRESENTACIONES_PRODUCTO_LISTADO" +
                        " WHERE FILAS BETWEEN "+begin+" AND "+end;
            LOGGER.debug("consulta cargar presentaciones producto "+consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            presentacionesProductoList.clear();
            while (res.next())
            {
                PresentacionesProducto nuevo=new PresentacionesProducto();
                nuevo.getCategoriasProducto().setCodCategoria(res.getInt("COD_CATEGORIA"));
                nuevo.getCategoriasProducto().setNombreCategoria(res.getString("NOMBRE_CATEGORIA"));
                nuevo.setCodPresentacion(res.getString("COD_PRESENTACION"));
                nuevo.setNombreProductoPresentacion(res.getString("nombre_producto_presentacion"));
                nuevo.getEnvasesSecundarios().setCodEnvaseSec(res.getString("COD_ENVASESEC"));
                nuevo.getEnvasesSecundarios().setNombreEnvaseSec(res.getString("NOMBRE_ENVASESEC"));
                nuevo.getProducto().setCodProducto(res.getString("cod_prod"));
                nuevo.getProducto().setNombreProducto(res.getString("nombre_prod"));
                nuevo.setCantidadPresentacion(res.getString("cantidad_presentacion"));
                nuevo.setCodAnterior(res.getString("cod_anterior"));
                nuevo.getLineaMKT().setNombreLineaMKT(res.getString("NOMBRE_LINEAMKT"));
                nuevo.getLineaMKT().setCodLineaMKT(res.getString("COD_LINEAMKT"));
                nuevo.getTiposMercaderia().setNombreTipoMercaderia(res.getString("nombre_tipomercaderia"));
                nuevo.getTiposMercaderia().setCodTipoMercaderia(res.getString("cod_tipomercaderia"));
                nuevo.getCartonesCorrugados().setNombreCarton(res.getString("NOMBRE_CARTON"));
                nuevo.getCartonesCorrugados().setCodCaton(res.getString("COD_CARTON"));
                nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("cod_estado_registro"));
                nuevo.getTiposPresentacion().setCodTipoPresentacion(res.getInt("cod_tipo_presentacion"));
                nuevo.getCategoriasProducto().setCodCategoria(res.getInt("cod_categoria"));
                nuevo.setObsPresentacion(res.getString("OBS_PRESENTACION"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("cod_tipo_programa_prod"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("nombre_tipo_programa_prod"));
                presentacionesProductoList.add(nuevo);
            }
            cantidadfilas=presentacionesProductoList.size();
           res.close();
           st.close();
           con.close();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        
    }
    /**
     * -------------------------------------------------------------------------
     * ESTADO REGISTRO
     * -------------------------------------------------------------------------
     **/
   
    private void cargarEnvaseSecundarioSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cod_envasesec,nombre_envasesec from envases_secundarios where cod_estado_registro=1 order by nombre_envasesec";
            ResultSet res = st.executeQuery(consulta);
            envasesSecundariosSelectList.clear();
            while (res.next()) 
            {
                envasesSecundariosSelectList.add(new SelectItem(res.getString("cod_envasesec"),res.getString("nombre_envasesec")));
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
    }
    
    private void cargarProductosSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select p.cod_prod,p.nombre_prod from PRODUCTOS p order by p.nombre_prod";
            ResultSet res = st.executeQuery(consulta);
            productosSelectList.clear();
            while (res.next())
            {
                productosSelectList.add(new SelectItem(res.getString("cod_prod"),res.getString("nombre_prod")));
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public void cargarLineaMKTSelectList()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cod_lineamkt,nombre_lineamkt from lineas_mkt where cod_estado_registro=1 order by nombre_lineamkt";
            ResultSet res = st.executeQuery(consulta);
            lineasMKTSelectList.clear();
            while (res.next())
            {
                lineasMKTSelectList.add(new SelectItem(res.getString("cod_lineamkt"),res.getString("nombre_lineamkt")));
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
    
    private void cargarTiposMercaderiaSelectList()
    {
        
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select cod_tipomercaderia,nombre_tipomercaderia from tipos_mercaderia where cod_estado_registro=1 and cod_tipomercaderia in (1,5,8,7) order by nombre_tipomercaderia";
            ResultSet res = st.executeQuery(consulta);
            tiposMercaderiaSelectList.clear();
            while (res.next())
            {
                tiposMercaderiaSelectList.add(new SelectItem(res.getString("cod_tipomercaderia"),res.getString("nombre_tipomercaderia")));
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
    
    

    
    
    
    public void cargarCategoriasProductoSelectList()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "SELECT cp.COD_CATEGORIA,cp.NOMBRE_CATEGORIA FROM CATEGORIAS_PRODUCTO cp order by cp.NOMBRE_CATEGORIA";
            ResultSet res = st.executeQuery(consulta);
            categoriaProductoSelectList.clear();
            while (res.next()) 
            {
                categoriaProductoSelectList.add(new SelectItem(res.getString("COD_CATEGORIA"),res.getString("NOMBRE_CATEGORIA")));
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
    public String actionCancelar(){

        this.redireccionar("navegadorpresentacionesproducto.jsf");
        return null;
    }
    
    public String guardarNuevaPresentacionProducto_action()throws SQLException
    {
        Connection conMySql=null;
        EnvioCorreoCreacionPresentacion  correo = null;
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select isnull(max(p.cod_presentacion),0)+1 as codPresentacion from PRESENTACIONES_PRODUCTO p";
            ResultSet res = st.executeQuery(consulta);
            int codPresentacion=0;
            while (res.next())codPresentacion=res.getInt("codPresentacion");
            consulta="insert into presentaciones_producto(cod_presentacion,cod_prod,cod_envasesec,"+
                    " cod_lineamkt,cantidad_presentacion,"+
                    " cod_tipomercaderia,obs_presentacion,cod_anterior,cod_estado_registro,nombre_producto_presentacion," +
                    " cod_tipo_presentacion,cod_categoria,cod_tipo_programa_prod)" +
                    "values('"+codPresentacion+"','"+presentacionesProductoAgregar.getProducto().getCodProducto()+"'," +
                    "'"+presentacionesProductoAgregar.getEnvasesSecundarios().getCodEnvaseSec()+"',"+
                    "'"+presentacionesProductoAgregar.getLineaMKT().getCodLineaMKT()+"',"+
                    "'"+presentacionesProductoAgregar.getCantidadPresentacion()+"',"+
                    "'"+presentacionesProductoAgregar.getTiposMercaderia().getCodTipoMercaderia()+"',"+
                    "'"+presentacionesProductoAgregar.getObsPresentacion()+"'," +
                    "'"+presentacionesProductoAgregar.getCodAnterior()+"',"+
                    "'"+presentacionesProductoAgregar.getEstadoReferencial().getCodEstadoRegistro()+"',"+
                    "'"+presentacionesProductoAgregar.getNombreProductoPresentacion()+"'," +
                    "'"+presentacionesProductoAgregar.getTiposPresentacion().getCodTipoPresentacion()+"'," +
                    "'"+presentacionesProductoAgregar.getCategoriasProducto().getCodCategoria()+"'," +
                    "'"+presentacionesProductoAgregar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"')";
            LOGGER.debug("consulta insertar presentacion "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se registro la presentacion secundaria");
            correo = new EnvioCorreoCreacionPresentacion(codPresentacion);
            con.commit();
            pst.close();
            res.close();
            st.close();
            if(presentacionesProductoAgregar.getTiposMercaderia().getCodTipoMercaderia().equals("5"))
            {
                conMySql=Util.openConnectionMySql();
                conMySql.setAutoCommit(false);
                StringBuilder consultaMySql=new StringBuilder("select l.codigo_linea");
                                        consultaMySql.append(" from lineas l");
                                        consultaMySql.append(" where l.lineazeus=").append(presentacionesProductoAgregar.getLineaMKT().getCodLineaMKT());
                Statement stMySql=conMySql.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet resMySql=stMySql.executeQuery(consultaMySql.toString());
                int codigoLineaHermes=0;
                if(resMySql.next())codigoLineaHermes=resMySql.getInt(1);
                consultaMySql=new StringBuilder("INSERT INTO muestras_medicas(codigo,descripcion,estado,cod_tipo_muestra,codigo_linea,codigo_anterior,stock_minimo,stock_reposicion,stock_maximo,principio_activo,cantidad_pres)");
                            consultaMySql.append("VALUES (");
                                    consultaMySql.append("'").append(codPresentacion).append("',");
                                    consultaMySql.append("'").append(presentacionesProductoAgregar.getNombreProductoPresentacion()).append("',");
                                    consultaMySql.append("1,");//estado
                                    consultaMySql.append("1,");//tipo muestra
                                    consultaMySql.append(codigoLineaHermes).append(",");//codigo linea
                                    consultaMySql.append("'").append(presentacionesProductoAgregar.getCodAnterior()).append("',");
                                    consultaMySql.append("0,");//stock minimo
                                    consultaMySql.append("0,");//stock reposicion
                                    consultaMySql.append("0,");//stock maximo
                                    consultaMySql.append("'',");//principio activo
                                    consultaMySql.append("'").append(presentacionesProductoAgregar.getCantidadPresentacion()).append("'");
                            consultaMySql.append(")");
                LOGGER.debug("consulta insertar base de datos hermes "+consultaMySql.toString());
                PreparedStatement pstMysql=conMySql.prepareStatement(consultaMySql.toString());
                if(pstMysql.executeUpdate()>0)LOGGER.info("se registro la presentacion en hermes");
                conMySql.commit();
            }
            mensaje="1";
        }
        catch (SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar la presentacion,intente de nuevo";
            LOGGER.warn("error", ex);
            con.rollback();
        }
        catch(Exception e)
        {
            mensaje="Ocurrio un error al momento de registrar la presentacion,intente de nuevo";
            LOGGER.warn("error", e);
            con.rollback();
        }
        finally
        {
            con.close();
            if(conMySql!=null)
                conMySql.close();
        }
        if(mensaje.equals("1"))
        {
            correo.start();
        }
        return null;
    }
    public String getCargarAgregarNuevaPresentacion()
    {
        this.cargarEstadosPresentacionesProductoTransaccionablesSelectList();
        presentacionesProductoAgregar=new PresentacionesProducto();
        return null;
    }
    
        
    public String siguientePaginaAction(){
        begin=begin+numrows;
        end=end+numrows;
        this.cargarPresentacionesProductoList();
        return null;
    }
    
    public String anteriorPaginaAction()
    {
        begin=begin-numrows;
        end=end-numrows;
        this.cargarPresentacionesProductoList();
        return null;
    }
    public String buscarPresentacionesProducto_action()
    {
        begin=0;
        end=20;
        this.cargarPresentacionesProductoList();
        return null;
    }
    private void cargarEstadosPresentacionesProductoSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select epp.COD_ESTADO_PRESENTACION_PRODUCTO,epp.NOMBRE_ESTADO_PRESENTACION_PRODUCTO")
                                                .append(" from ESTADOS_PRESENTACIONES_PRODUCTO epp")
                                                .append(" order by epp.NOMBRE_ESTADO_PRESENTACION_PRODUCTO");
            LOGGER.debug("consulta cargar estados presnetacion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            estadosPresentacionesProductoSelectList=new ArrayList<SelectItem>();
            while (res.next()) {
                estadosPresentacionesProductoSelectList.add(new SelectItem(res.getString("COD_ESTADO_PRESENTACION_PRODUCTO"),res.getString("NOMBRE_ESTADO_PRESENTACION_PRODUCTO")));
            }
            
            mensaje = "1";
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
    }
    private void cargarEstadosPresentacionesProductoTransaccionablesSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select epp.COD_ESTADO_PRESENTACION_PRODUCTO,epp.NOMBRE_ESTADO_PRESENTACION_PRODUCTO")
                                                .append(" from ESTADOS_PRESENTACIONES_PRODUCTO epp")
                                                .append(" where epp.TRANSACCIONABLE_PRODUCCION=1")
                                                        .append(" and epp.REGISTRO_NUEVA_PRESENTACION_IND = 1")
                                                .append(" order by epp.NOMBRE_ESTADO_PRESENTACION_PRODUCTO");
            LOGGER.debug("consulta cargar estados presnetacion "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            estadosPresentacionesProductoSelectList=new ArrayList<SelectItem>();
            while (res.next()) {
                estadosPresentacionesProductoSelectList.add(new SelectItem(res.getString("COD_ESTADO_PRESENTACION_PRODUCTO"),res.getString("NOMBRE_ESTADO_PRESENTACION_PRODUCTO")));
            }
            
            mensaje = "1";
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
    }
    public String getCargarProductosPresentaciones()
    {
        this.cargarEstadosPresentacionesProductoSelectList();
        this.cargarLineaMKTSelectList();
        this.cargarCategoriasProductoSelectList();
        this.cargarTiposProgramaProduccionSelectList();
        this.cargarProductosSelectList();
        this.cargarTiposPresentacionSelectList();
        this.cargarEnvaseSecundarioSelectList();
        this.cargarTiposMercaderiaSelectList();
        cargarPresentacionesProductoList();
        
        return null;
    }
    private void cargarTiposProgramaProduccionSelectList()
    {
        try
        {
            con=Util.openConnection(con);
            String consulta = " select tppr.COD_TIPO_PROGRAMA_PROD,tppr.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION tppr where tppr.COD_ESTADO_REGISTRO =1 ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            tiposProgramaProduccionSelectList.clear();
            while(res.next())
            {
                tiposProgramaProduccionSelectList.add(new SelectItem(res.getString("COD_TIPO_PROGRAMA_PROD"),res.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
            }
            st.close();
            con.close();
        } 
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    public String guardarActivarInactivarPresentacion_action()throws SQLException
    {
        mensaje="";
        Connection conMySql=null;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta = "update PRESENTACIONES_PRODUCTO set cod_estado_registro='"+presentacionesProductoEditar.getEstadoReferencial().getCodEstadoRegistro()+"'" +
                              " where cod_presentacion='"+presentacionesProductoEditar.getCodPresentacion()+"'";
            LOGGER.debug("consulta cambiar estado presentacion producto "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)LOGGER.info("se edito la presentacion");
            con.commit();
            pst.close();
            if(presentacionesProductoEditar.getTiposMercaderia().getCodTipoMercaderia().equals("5"))
            {
                conMySql=Util.openConnectionMySql();
                conMySql.setAutoCommit(false);
                StringBuilder consultaMySql=new StringBuilder(" update muestras_medicas ");
                                            consultaMySql.append(" set estado=").append(presentacionesProductoEditar.getEstadoReferencial().getCodEstadoRegistro());
                                            consultaMySql.append(" where codigo='").append(presentacionesProductoEditar.getCodAnterior()).append("'");
                LOGGER.debug("consulta editar estado hermes "+consultaMySql.toString());
                PreparedStatement pstMySql=conMySql.prepareStatement(consultaMySql.toString());
                if(pstMySql.executeUpdate()>0)LOGGER.info("se actualizo estado hermes");
                conMySql.commit();
            }
            mensaje="1";
        }
        catch (SQLException ex) 
        {
            mensaje="Ocurrio un error al momento de activar/inactivar la presentación, intente de nuevo";
            LOGGER.warn("error", ex);
            con.rollback();
        }
        finally
        {
            con.close();
            if(conMySql!=null)
            {
                conMySql.close();
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarPresentacionesProductoList();
        }
        return null;
    }


    public String redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<SelectItem> getProductosSelectList() {
        return productosSelectList;
    }

    public void setProductosSelectList(List<SelectItem> productosSelectList) {
        this.productosSelectList = productosSelectList;
    }

    public List<SelectItem> getTiposPresentacionSelecList() {
        return tiposPresentacionSelecList;
    }

    public void setTiposPresentacionSelecList(List<SelectItem> tiposPresentacionSelecList) {
        this.tiposPresentacionSelecList = tiposPresentacionSelecList;
    }

    public PresentacionesProducto getPresentacionesProductoAgregar() {
        return presentacionesProductoAgregar;
    }

    public void setPresentacionesProductoAgregar(PresentacionesProducto presentacionesProductoAgregar) {
        this.presentacionesProductoAgregar = presentacionesProductoAgregar;
    }

    public List<SelectItem> getEnvasesSecundariosSelectList() {
        return envasesSecundariosSelectList;
    }

    public void setEnvasesSecundariosSelectList(List<SelectItem> envasesSecundariosSelectList) {
        this.envasesSecundariosSelectList = envasesSecundariosSelectList;
    }

    public List<SelectItem> getTiposMercaderiaSelectList() {
        return tiposMercaderiaSelectList;
    }

    public void setTiposMercaderiaSelectList(List<SelectItem> tiposMercaderiaSelectList) {
        this.tiposMercaderiaSelectList = tiposMercaderiaSelectList;
    }

    public List<SelectItem> getLineasMKTSelectList() {
        return lineasMKTSelectList;
    }

    public void setLineasMKTSelectList(List<SelectItem> lineasMKTSelectList) {
        this.lineasMKTSelectList = lineasMKTSelectList;
    }

    public List<SelectItem> getCategoriaProductoSelectList() {
        return categoriaProductoSelectList;
    }

    public void setCategoriaProductoSelectList(List<SelectItem> categoriaProductoSelectList) {
        this.categoriaProductoSelectList = categoriaProductoSelectList;
    }

    public List<SelectItem> getTiposProgramaProduccionSelectList() {
        return tiposProgramaProduccionSelectList;
    }

    public void setTiposProgramaProduccionSelectList(List<SelectItem> tiposProgramaProduccionSelectList) {
        this.tiposProgramaProduccionSelectList = tiposProgramaProduccionSelectList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public PresentacionesProducto getPresentacionesProductoEditar() {
        return presentacionesProductoEditar;
    }

    public void setPresentacionesProductoEditar(PresentacionesProducto presentacionesProductoEditar) {
        this.presentacionesProductoEditar = presentacionesProductoEditar;
    }

    public PresentacionesProducto getPresentacionesProductoBuscar() {
        return presentacionesProductoBuscar;
    }

    public void setPresentacionesProductoBuscar(PresentacionesProducto presentacionesProductoBuscar) {
        this.presentacionesProductoBuscar = presentacionesProductoBuscar;
    }

    
    // <editor-fold defaultstate="collapsed" desc="getter and setter">
        public List getPresentacionesProductoList() {
            return presentacionesProductoList;
        }

        public void setPresentacionesProductoList(List presentacionesProductoList) {
            this.presentacionesProductoList = presentacionesProductoList;
        }

        public List getPresentacionesProductoEli() {
            return presentacionesProductoEli;
        }

        public void setPresentacionesProductoEli(List presentacionesProductoEli) {
            this.presentacionesProductoEli = presentacionesProductoEli;
        }

        public List getPresentacionesProductoEli2() {
            return presentacionesProductoEli2;
        }

        public void setPresentacionesProductoEli2(List presentacionesProductoEli2) {
            this.presentacionesProductoEli2 = presentacionesProductoEli2;
        }


        public Connection getCon() {
            return con;
        }

        public void setCon(Connection con) {
            this.con = con;
        }

        public List getEstadoRegistro() {
            return estadoRegistro;
        }

        public void setEstadoRegistro(List estadoRegistro) {
            this.estadoRegistro = estadoRegistro;
        }




        public String getCodigo() {
            return codigo;
        }

        public void setCodigo(String codigo) {
            this.codigo = codigo;
        }

        public ResultDataModel getComponentesList() {
            return componentesList;
        }

        public void setComponentesList(ResultDataModel componentesList) {
            this.componentesList = componentesList;
        }

        public List<ComponentesProd> getListaComponentesBuscar() {
            return listaComponentesBuscar;
        }

        public void setListaComponentesBuscar(List<ComponentesProd> listaComponentesBuscar) {
            this.listaComponentesBuscar = listaComponentesBuscar;
        }

        public List<ComponentesProd> getListaComponentesSeleccionados() {
            return listaComponentesSeleccionados;
        }

        public void setListaComponentesSeleccionados(List<ComponentesProd> listaComponentesSeleccionados) {
            this.listaComponentesSeleccionados = listaComponentesSeleccionados;
        }


        public List getEliminaComponentesSeleccionados() {
            return eliminaComponentesSeleccionados;
        }

        public void setEliminaComponentesSeleccionados(List eliminaComponentesSeleccionados) {
            this.eliminaComponentesSeleccionados = eliminaComponentesSeleccionados;
        }

        public boolean isSwEliminaSi() {
            return swEliminaSi;
        }

        public void setSwEliminaSi(boolean swEliminaSi) {
            this.swEliminaSi = swEliminaSi;
        }

        public boolean isSwEliminaNo() {
            return swEliminaNo;
        }

        public void setSwEliminaNo(boolean swEliminaNo) {
            this.swEliminaNo = swEliminaNo;
        }

        public String getPrincipioActivo() {
            return principioActivo;
        }

        public void setPrincipioActivo(String principioActivo) {
            this.principioActivo = principioActivo;
        }

        public List getListaComponentesLista() {
            return listaComponentesLista;
        }

        public void setListaComponentesLista(List listaComponentesLista) {
            this.listaComponentesLista = listaComponentesLista;
        }

        public List getComponentespresentaciones() {
            return componentespresentaciones;
        }

        public void setComponentespresentaciones(List componentespresentaciones) {
            this.componentespresentaciones = componentespresentaciones;
        }




        public HtmlDataTable getComponentesSeleccionadosDataTable() {
            return componentesSeleccionadosDataTable;
        }

        public void setComponentesSeleccionadosDataTable(HtmlDataTable componentesSeleccionadosDataTable) {
            this.componentesSeleccionadosDataTable = componentesSeleccionadosDataTable;
        }

        public ComponentesProd getEditarComponente() {
            return editarComponente;
        }

        public void setEditarComponente(ComponentesProd editarComponente) {
            this.editarComponente = editarComponente;
        }

        public List getComponenteEditarList() {
            return componenteEditarList;
        }

        public void setComponenteEditarList(List componenteEditarList) {
            this.componenteEditarList = componenteEditarList;
        }

        public String getEditarCantidadCompprod() {
            return editarCantidadCompprod;
        }

        public void setEditarCantidadCompprod(String editarCantidadCompprod) {
            this.editarCantidadCompprod = editarCantidadCompprod;
        }
        

        public String getEditarCodCompprod() {
            return editarCodCompprod;
        }

    public List<SelectItem> getEstadosPresentacionesProductoSelectList() {
        return estadosPresentacionesProductoSelectList;
    }

    public void setEstadosPresentacionesProductoSelectList(List<SelectItem> estadosPresentacionesProductoSelectList) {
        this.estadosPresentacionesProductoSelectList = estadosPresentacionesProductoSelectList;
    }

        public void setEditarCodCompprod(String editarCodCompprod) {
            this.editarCodCompprod = editarCodCompprod;
        }

        public String getEditarNombreProdSemiterminado() {
            return editarNombreProdSemiterminado;
        }

        public void setEditarNombreProdSemiterminado(String editarNombreProdSemiterminado) {
            this.editarNombreProdSemiterminado = editarNombreProdSemiterminado;
        }

        public HtmlDataTable getComponentesBuscarDataTable() {
            return componentesBuscarDataTable;
        }

        public void setComponentesBuscarDataTable(HtmlDataTable componentesBuscarDataTable) {
            this.componentesBuscarDataTable = componentesBuscarDataTable;
        }


        public HtmlSelectOneMenu getComponentesEditarSelectOneMenu() {
            return componentesEditarSelectOneMenu;
        }

        public void setComponentesEditarSelectOneMenu(HtmlSelectOneMenu componentesEditarSelectOneMenu) {
            this.componentesEditarSelectOneMenu = componentesEditarSelectOneMenu;
        }
    //</editor-fold>
}
