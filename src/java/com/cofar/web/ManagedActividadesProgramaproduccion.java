
/*
 * ManagedCartonesCorrugados.java
 * Created on 25 de Junio de 2008, 10:50
 */

package com.cofar.web;


import com.cofar.bean.ActividadesFormulaMaestra;
import com.cofar.bean.ActividadesProgramaProduccion;
import com.cofar.bean.DefectosEnvasePersonal;
import com.cofar.bean.DefectosEnvaseProgramaProduccion;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.SeguimientoProgramaProduccion;
import com.cofar.bean.SeguimientoProgramaProduccionPersonal;
import com.cofar.dao.DaoComponentesPresProd;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.el.ELContext;
import javax.el.ExpressionFactory;
import javax.el.ValueExpression;
import javax.faces.component.UIComponent;
import javax.faces.component.html.HtmlOutputText;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import org.joda.time.DateTime;
import org.richfaces.component.html.HtmlDataTable;

public class ManagedActividadesProgramaproduccion extends ManagedBean
{

    private List<SelectItem> tiposProgramaProduccionSelectList;
    private ActividadesProgramaProduccion actividadesProgramaProduccionbean=new ActividadesProgramaProduccion();
    private SeguimientoProgramaProduccion seguimientoProgramaProduccionbean=new SeguimientoProgramaProduccion();
    private List seguimientoProgramaProduccionList=new ArrayList();
    private List seguimientoProgramaProduccionAdicionarList=new ArrayList();
    private List seguimientoProgramaProduccionEditarList=new ArrayList();
    private List estadoRegistro=new ArrayList();
    private List seguimientoProgramaProduccionEliminar=new ArrayList();
    private List seguimientoProgramaProduccionNoEliminar=new ArrayList();
    private Connection con;
    private boolean swEliminaSi;
    private boolean swEliminaNo;
    private String codigo="";
    private String codigoProgramaProd="";
    private String codigoFormulaMaestra="";
    private String codigoCompProd="";
    private String codigoLoteProd="";
    private String codActividad="";
    private List actividadesList=new ArrayList();
    private List actividadesSeguimientoList=new ArrayList();
    private String nombreComProd="";
    private String nombreAreaEmpresaTiempo="";

    private List maquinariasSeguimientoProgramaProduccionList=new ArrayList();
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    private String codAreaEmpresa ="";
    ProgramaProduccion programaProduccion = new ProgramaProduccion();
    HtmlDataTable seguimientoProgramaProduccionDataTable = new HtmlDataTable();
    SeguimientoProgramaProduccion seguimientoProgramaProduccion = new SeguimientoProgramaProduccion();
    SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal = new SeguimientoProgramaProduccionPersonal();
    SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonalEditar = new SeguimientoProgramaProduccionPersonal();
    List personalList = new ArrayList();
    HtmlDataTable seguimientoProgramaProduccionPersonalDataTable = new HtmlDataTable();
    String codPresentacion = "0";
    List presentacionesProductoList = new ArrayList();
    String mensaje = "";
    private List<SelectItem> operariosList=new ArrayList<SelectItem>();
    private List<SelectItem> defectosEnvaseList=new ArrayList<SelectItem>();
    private HtmlDataTable defectosEnvaseLoteHtmlDataTable=new HtmlDataTable();
    private List<DefectosEnvaseProgramaProduccion> defectosEnvaseLoteList=new ArrayList<DefectosEnvaseProgramaProduccion>();
    private List<String> headerColumns=new ArrayList<String>();
    public ManagedActividadesProgramaproduccion() {
        // cargarActividadFormulaMaestra();
    }
    /**
     * metodo que genera los codigos
     * correlativamente
     */
    public class ActividadesSeguimientoProgramaProduccion{
    private ActividadesFormulaMaestra actividadesFormulaMaestra = new ActividadesFormulaMaestra();
    private ActividadesProgramaProduccion actividadesProgramaProduccion = new ActividadesProgramaProduccion();
    private SeguimientoProgramaProduccion seguimientoProgramaProduccion = new SeguimientoProgramaProduccion();
    private Date fechaInicio=new Date(); //fechas de seguimiento de programa produccion
    private Date fechaFinal =new Date();
    private List maquinariasList = new ArrayList();

        public ActividadesFormulaMaestra getActividadesFormulaMaestra() {
            return actividadesFormulaMaestra;
        }

        public void setActividadesFormulaMaestra(ActividadesFormulaMaestra actividadesFormulaMaestra) {
            this.actividadesFormulaMaestra = actividadesFormulaMaestra;
        }
        public ActividadesProgramaProduccion getActividadesProgramaProduccion() {
            return actividadesProgramaProduccion;
        }

        public void setActividadesProgramaProduccion(ActividadesProgramaProduccion actividadesProgramaProduccion) {
            this.actividadesProgramaProduccion = actividadesProgramaProduccion;
        }

        public SeguimientoProgramaProduccion getSeguimientoProgramaProduccion() {
            return seguimientoProgramaProduccion;
        }

        public void setSeguimientoProgramaProduccion(SeguimientoProgramaProduccion seguimientoProgramaProduccion) {
            this.seguimientoProgramaProduccion = seguimientoProgramaProduccion;
        }

        public Date getFechaFinal() {
            return fechaFinal;
        }

        public void setFechaFinal(Date fechaFinal) {
            this.fechaFinal = fechaFinal;
        }

        public Date getFechaInicio() {
            return fechaInicio;
        }

        public void setFechaInicio(Date fechaInicio) {
            this.fechaInicio = fechaInicio;
        }

        public List getMaquinariasList() {
            return maquinariasList;
        }

        public void setMaquinariasList(List maquinariasList) {
            this.maquinariasList = maquinariasList;
        }
    }

    public String getObtenerCodigo(){
        
        String codPrograma=Util.getParameter("codigo");
        String codFormula=Util.getParameter("cod_formula");
        String codComProd=Util.getParameter("cod_comp_prod");
        String codLote=Util.getParameter("cod_lote");
        codAreaEmpresa=Util.getParameter("codTipoActividadProduccion")!=null?Util.getParameter("codTipoActividadProduccion"):"";
        
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+codPrograma);
        if(codPrograma!=null){
            setCodigoProgramaProd(codPrograma);
        }
        if(codFormula!=null){
            setCodigoFormulaMaestra(codFormula);
        }
        if(codComProd!=null){
            setCodigoCompProd(codComProd);
        }
        if(codLote!=null){
            setCodigoLoteProd(codLote);
        }
        //cargarActividadProgramaProduccion();
        this.cargarActividadSeguimientoProgramaProduccion();
        cargarNombreComProd();
        return "";
    }
    
    public String getObtenerCodigoSeguimiento(){
        
        String codActividadPrograma=Util.getParameter("codigo");
        String codPrograma=Util.getParameter("cod_programa_prod");
        String codFormula=Util.getParameter("cod_formula_maestra");
        String codComProd=Util.getParameter("cod_com_prod");
        String codLote=Util.getParameter("cod_lote_prod");
        System.out.println("cxxxxxxxxxxxxxxxxxxxxxxxod:"+codPrograma);
        if(codPrograma!=null){
            setCodigoProgramaProd(codPrograma);
        }
        if(codFormula!=null){
            setCodigoFormulaMaestra(codFormula);
        }
        if(codComProd!=null){
            setCodigoCompProd(codComProd);
        }
        if(codLote!=null){
            setCodigoLoteProd(codLote);
        }
        
        if(codActividadPrograma!=null){
            setCodigo(codActividadPrograma);
        }
        
        cargarSeguimientoProgramaProduccion();
        cargarNombreComProd();
        return "";
    }
    public void cargarActividadProgramaProduccion(){
        try {
            
            String sql="select ap.COD_ACTIVIDAD,fm.COD_FORMULA_MAESTRA,ap.NOMBRE_ACTIVIDAD," ;
            sql+=" af.COD_ACTIVIDAD_PROGRAMA,af.orden_actividad" ;
            sql+=" from ACTIVIDADES_PRODUCCION ap,ACTIVIDADES_PROGRAMA_PRODUCCION af,FORMULA_MAESTRA fm";
            sql+=" where ap.COD_ACTIVIDAD = af.COD_ACTIVIDAD AND fm.COD_FORMULA_MAESTRA = af.COD_FORMULA_MAESTRA and ";
            sql+=" af.cod_formula_maestra='"+getCodigoFormulaMaestra()+"' and af.COD_ESTADO_ACTIVIDAD=1";
            sql+=" order by orden_actividad asc";
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            getActividadesList().clear();
            rs.first();
            for(int i=0;i<rows;i++){
                ActividadesProgramaProduccion bean=new ActividadesProgramaProduccion();
                bean.getActividadesProduccion().setCodActividad(rs.getInt(1));
                bean.getFormulaMaestra().setCodFormulaMaestra(rs.getString(2));
                bean.getActividadesProduccion().setNombreActividad(rs.getString(3));
                bean.setCodActividadPrograma(rs.getString(4));
                bean.setOrdenActividad(rs.getString(5));
                getActividadesList().add(bean);
                rs.next();
            }
            
            if(rs!=null){
                rs.close();
                st.close();
            }
            
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarActividadSeguimientoProgramaProduccion(){
        try {
            
            String sql="select ap.COD_ACTIVIDAD,fm.COD_FORMULA_MAESTRA,ap.NOMBRE_ACTIVIDAD," ;
            sql+=" af.COD_ACTIVIDAD_PROGRAMA,af.orden_actividad" ;
            sql+=" from ACTIVIDADES_PRODUCCION ap,ACTIVIDADES_PROGRAMA_PRODUCCION af,FORMULA_MAESTRA fm";
            sql+=" where ap.COD_ACTIVIDAD = af.COD_ACTIVIDAD AND fm.COD_FORMULA_MAESTRA = af.COD_FORMULA_MAESTRA and ";
            sql+=" af.cod_formula_maestra='"+getCodigoFormulaMaestra()+"' and af.COD_ESTADO_ACTIVIDAD=1 and ap.COD_TIPO_ACTIVIDAD_PRODUCCION="+codAreaEmpresa;
            sql+=" order by orden_actividad asc";

            sql =   " select ap.COD_ACTIVIDAD,fm.COD_FORMULA_MAESTRA,ap.NOMBRE_ACTIVIDAD, af.COD_ACTIVIDAD_FORMULA ,af.orden_actividad " +
                    " from ACTIVIDADES_PRODUCCION ap,ACTIVIDADES_FORMULA_MAESTRA af,FORMULA_MAESTRA fm " +
                    " where ap.COD_ACTIVIDAD = af.COD_ACTIVIDAD AND fm.COD_FORMULA_MAESTRA = af.COD_FORMULA_MAESTRA   " +
                    " and af.cod_formula_maestra='"+getCodigoFormulaMaestra()+"'   " +
                    " and ap.COD_TIPO_ACTIVIDAD_PRODUCCION= "+codAreaEmpresa+" " +
                    " order by orden_actividad asc ";

            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            actividadesSeguimientoList.clear();
            rs.first();
            for(int i=0;i<rows;i++){

                ActividadesSeguimientoProgramaProduccion actividadesSeguimientoProgProd = new ActividadesSeguimientoProgramaProduccion();
                //actividadesSeguimientoProgProd.getActividadesProgramaProduccion().getActividadesProduccion().setCodActividad(rs.getString("COD_ACTIVIDAD"));
                //actividadesSeguimientoProgProd.getActividadesProgramaProduccion().getFormulaMaestra().setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                //actividadesSeguimientoProgProd.getActividadesProgramaProduccion().getActividadesProduccion().setNombreActividad(rs.getString("NOMBRE_ACTIVIDAD"));
                //actividadesSeguimientoProgProd.getActividadesProgramaProduccion().setCodActividadPrograma(rs.getString("COD_ACTIVIDAD_PROGRAMA"));
                //actividadesSeguimientoProgProd.getActividadesProgramaProduccion().setOrdenActividad(rs.getString("orden_actividad"));

                actividadesSeguimientoProgProd.getActividadesFormulaMaestra().getActividadesProduccion().setCodActividad(rs.getInt("COD_ACTIVIDAD"));
                actividadesSeguimientoProgProd.getActividadesFormulaMaestra().getFormulaMaestra().setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                actividadesSeguimientoProgProd.getActividadesFormulaMaestra().getActividadesProduccion().setNombreActividad(rs.getString("NOMBRE_ACTIVIDAD"));
                actividadesSeguimientoProgProd.getActividadesFormulaMaestra().setCodActividadFormula(rs.getInt("COD_ACTIVIDAD_FORMULA"));
                actividadesSeguimientoProgProd.getActividadesFormulaMaestra().setOrdenActividad(rs.getInt("orden_actividad"));


            String consulta="select top 1 s.COD_SEGUIMIENTO_PROGRAMA,s.HORAS_HOMBRE,s.HORAS_MAQUINA,s.FECHA_INICIO,s.FECHA_FINAL,s.HORA_INICIO,s.HORA_FINAL" +
                    ",(select isnull(M.COD_MAQUINA,'') from MAQUINARIAS M where s.COD_MAQUINA=M.COD_MAQUINA ) COD_MAQUINA" ;
            consulta+=" from SEGUIMIENTO_PROGRAMA_PRODUCCION s " ;
            consulta+=" where s.COD_ACTIVIDAD_PROGRAMA='"+actividadesSeguimientoProgProd.getActividadesFormulaMaestra().getCodActividadFormula() +"' and s.COD_PROGRAMA_PROD='"+codigoProgramaProd+"' and s.COD_COMPPROD='"+codigoCompProd+"'";
            consulta+=" and s.COD_FORMULA_MAESTRA='"+codigoFormulaMaestra+"' and s.COD_LOTE_PRODUCCION='"+codigoLoteProd+"' order by COD_SEGUIMIENTO_PROGRAMA desc";
            System.out.println("cargar:"+consulta);
            setCon(Util.openConnection(getCon()));
            Statement st1=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(consulta);
            rs1.last();
            int filas=rs1.getRow();
            rs1.first();
            System.out.println("consulta del seguimiento programa produccion " +consulta);
            for(int j=0;j<filas;j++){
                actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().setCodSeguimientoPrograma(rs1.getString("COD_SEGUIMIENTO_PROGRAMA"));
                actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().setHorasHombre(rs1.getDouble("HORAS_HOMBRE"));
                actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().setHorasMaquina(rs1.getDouble("HORAS_MAQUINA"));
                String fechaAux[]=rs1.getString("FECHA_INICIO").split(" ");
                fechaAux=fechaAux[0].split("-");                
                //actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().setFechaInicio(fechaAux[2]+"/"+fechaAux[1]+"/"+fechaAux[0]);
                actividadesSeguimientoProgProd.setFechaInicio(sdf.parse(fechaAux[0]+"/"+fechaAux[1]+"/"+fechaAux[2]));
                fechaAux=rs1.getString("FECHA_FINAL").split(" ");
                fechaAux=fechaAux[0].split("-");                
                //actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().setFechaFinal(fechaAux[2]+"/"+fechaAux[1]+"/"+fechaAux[0]);
                actividadesSeguimientoProgProd.setFechaFinal(sdf.parse(fechaAux[0]+"/"+fechaAux[1]+"/"+fechaAux[2]));
                actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().setHoraInicio(rs1.getString("HORA_INICIO"));
                actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().setHoraFinal(rs1.getString("HORA_FINAL"));
                actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getMaquinaria().setCodMaquina(rs1.getString("COD_MAQUINA"));                
                rs1.next();
            }
                actividadesSeguimientoProgProd.setMaquinariasList(this.cargarMaquinariasActividad(codigoCompProd, codigoFormulaMaestra, actividadesSeguimientoProgProd.getActividadesFormulaMaestra().getActividadesProduccion().getCodActividad()));
                actividadesSeguimientoList.add(actividadesSeguimientoProgProd);
                rs.next();
            }

            if(rs!=null){
                rs.close();
                st.close();
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
    }
   public List cargarMaquinariasActividad(String codCompProd,String codFormulaMaestra,int codActividad){
       List maquinariasList = new ArrayList();
        try {
            maquinariasList.clear();
            setCon(Util.openConnection(getCon()));
            String sql=" SELECT M.COD_MAQUINA, M.NOMBRE_MAQUINA " +
                    " FROM FORMULA_MAESTRA FM INNER JOIN ACTIVIDADES_FORMULA_MAESTRA AFM  " +
                    " ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA INNER JOIN MAQUINARIA_ACTIVIDADES_FORMULA MAF " +
                    " ON MAF.COD_ACTIVIDAD_FORMULA = AFM.COD_ACTIVIDAD_FORMULA INNER JOIN MAQUINARIAS M ON MAF.COD_MAQUINA = M.COD_MAQUINA " +
                    " WHERE FM.COD_COMPPROD ="+codCompProd+"  AND FM.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'  AND AFM.COD_ACTIVIDAD = '"+codActividad+"'" ;

            System.out.println("select cargar maquinarias actividad:"+sql);
            ResultSet rs=null;

            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
                  maquinariasList.add(new SelectItem("0","-NINGUNO-"));
                while(rs.next()){
                    maquinariasList.add(new SelectItem(rs.getString("COD_MAQUINA"),rs.getString("NOMBRE_MAQUINA")));
                }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
       return maquinariasList;
    }

   public String guardarActividadesSeguimientoProgramaProduccion_action(){
        try {

             Iterator i= actividadesSeguimientoList.iterator();
        while (i.hasNext()){
            ActividadesSeguimientoProgramaProduccion actividadesSeguimientoProgProd = (ActividadesSeguimientoProgramaProduccion) i.next();
            //primero borrar los datos de seguimiento del producto
            String consulta = " delete from SEGUIMIENTO_PROGRAMA_PRODUCCION WHERE COD_PROGRAMA_PROD='"+codigoProgramaProd+"'  and COD_COMPPROD='"+codigoCompProd+ "'  " +
                    " and COD_FORMULA_MAESTRA='"+codigoFormulaMaestra+"' and COD_LOTE_PRODUCCION='"+codigoLoteProd+"' and COD_ACTIVIDAD_PROGRAMA='"+actividadesSeguimientoProgProd.getActividadesFormulaMaestra().getCodActividadFormula()+"'";
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(consulta);
            System.out.println("borrar seguimiento :"+consulta);
            int result=st.executeUpdate();
            
            //segundo insertar el nuevo seguimiento del producto
            String sql="insert into SEGUIMIENTO_PROGRAMA_PRODUCCION(COD_SEGUIMIENTO_PROGRAMA,COD_PROGRAMA_PROD,COD_COMPPROD,COD_FORMULA_MAESTRA,COD_LOTE_PRODUCCION,";
            sql+=" COD_ACTIVIDAD_PROGRAMA,HORAS_HOMBRE,HORAS_MAQUINA,FECHA_INICIO,FECHA_FINAL,HORA_INICIO,HORA_FINAL,COD_MAQUINA)values(";
            sql+="'"+this.obtenerCodigoSeguimientoPrograma()+"','"+codigoProgramaProd+"','"+codigoCompProd+"','"+codigoFormulaMaestra+"','"+codigoLoteProd+"',";
            sql+="'"+actividadesSeguimientoProgProd.getActividadesProgramaProduccion().getCodActividadPrograma()+"','"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getHorasHombre()+"','"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getHorasMaquina()+"',";
            sql+="'"+sdf.format(actividadesSeguimientoProgProd.getFechaInicio())+"','"+sdf.format(actividadesSeguimientoProgProd.getFechaFinal())+"',";
            sql+="'"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getHoraInicio()+"','"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getHoraFinal()+"','"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getMaquinaria().getCodMaquina()+"')";

            sql="insert into SEGUIMIENTO_PROGRAMA_PRODUCCION(COD_SEGUIMIENTO_PROGRAMA,COD_PROGRAMA_PROD,COD_COMPPROD,COD_FORMULA_MAESTRA,COD_LOTE_PRODUCCION,";
            sql+=" COD_ACTIVIDAD_PROGRAMA,HORAS_HOMBRE,HORAS_MAQUINA,FECHA_INICIO,FECHA_FINAL,HORA_INICIO,HORA_FINAL,COD_MAQUINA)values(";
            sql+="'"+this.obtenerCodigoSeguimientoPrograma()+"','"+codigoProgramaProd+"','"+codigoCompProd+"','"+codigoFormulaMaestra+"','"+codigoLoteProd+"',";
            sql+="'"+actividadesSeguimientoProgProd.getActividadesFormulaMaestra().getCodActividadFormula()+"','"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getHorasHombre()+"','"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getHorasMaquina()+"',";
            sql+="'"+sdf.format(actividadesSeguimientoProgProd.getFechaInicio())+"','"+sdf.format(actividadesSeguimientoProgProd.getFechaFinal())+"',";
            sql+="'"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getHoraInicio()+"','"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getHoraFinal()+"','"+actividadesSeguimientoProgProd.getSeguimientoProgramaProduccion().getMaquinaria().getCodMaquina()+"')";
            //cuando guarde la actividad Pesaje y las horas hombre o las horas maquina sean mayor a cero se debe cambiar el estado
            // de Programa Produccion  a estado 'EN PROCESO'
            //this.verificaProcesoPesaje(actividadesSeguimientoProgProd);

            System.out.println("insertar seguimiento :"+sql);
            PreparedStatement st1=getCon().prepareStatement(sql);
            int result1=st1.executeUpdate();
        }

        } catch (Exception e) {
            e.printStackTrace();
        }
        this.redireccionar("../programaProduccion/navegador_programa_produccion.jsf");
        return null;
    }
   public void verificaProcesoPesajeX(ActividadesSeguimientoProgramaProduccion actividadesSeguimientoProgramaProduccion){
       try {
            if(actividadesSeguimientoProgramaProduccion.getActividadesFormulaMaestra().getActividadesProduccion().getCodActividad()==76
                    && (actividadesSeguimientoProgramaProduccion.getSeguimientoProgramaProduccion().getHorasHombre()>0 ||
                        actividadesSeguimientoProgramaProduccion.getSeguimientoProgramaProduccion().getHorasMaquina()>0)){
                String consulta = " UPDATE PROGRAMA_PRODUCCION  SET COD_ESTADO_PROGRAMA = 7 WHERE COD_PROGRAMA_PROD = '" + codigoProgramaProd +"'"+
                    " AND COD_COMPPROD ='"+codigoCompProd+"' AND COD_FORMULA_MAESTRA ='"+codigoFormulaMaestra+"' AND COD_LOTE_PRODUCCION='"+codigoLoteProd+"' " +
                    " AND COD_ESTADO_PROGRAMA<>6 ";
                System.out.println("consulta cambio estado programa produccion " + consulta);

                setCon(Util.openConnection(getCon()));
                Statement st = con.createStatement();
                st.executeUpdate(consulta);
            }
       } catch (Exception e) {
           e.printStackTrace();
       }
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

   public String obtenerCodigoSeguimientoPrograma(){
        String codigoSeguimientoPrograma="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select MAX(s.COD_SEGUIMIENTO_PROGRAMA)+1 from SEGUIMIENTO_PROGRAMA_PRODUCCION s";
            PreparedStatement st=getCon().prepareStatement(sql);
            System.out.println("sql:MAX:"+sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigoSeguimientoPrograma=rs.getString(1);
            if(codigoSeguimientoPrograma==null)
                codigoSeguimientoPrograma="1";
            
            System.out.println("coiogogo:"+codigoSeguimientoPrograma);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  codigoSeguimientoPrograma;
    }

    public void cargarSeguimientoProgramaProduccion(){
        try {
            
            String sql="select s.COD_SEGUIMIENTO_PROGRAMA,s.HORAS_HOMBRE,s.HORAS_MAQUINA,s.FECHA_INICIO,s.FECHA_FINAL,s.HORA_INICIO,s.HORA_FINAL,M.COD_MAQUINA,M.NOMBRE_MAQUINA" ;
            sql+=" from SEGUIMIENTO_PROGRAMA_PRODUCCION s INNER JOIN MAQUINARIAS M on s.COD_MAQUINA=M.COD_MAQUINA " ;
            sql+=" where s.COD_ACTIVIDAD_PROGRAMA='"+codigo+"' and s.COD_PROGRAMA_PROD='"+codigoProgramaProd+"' and s.COD_COMPPROD='"+codigoCompProd+"'";
            sql+=" and s.COD_FORMULA_MAESTRA='"+codigoFormulaMaestra+"' and s.COD_LOTE_PRODUCCION='"+codigoLoteProd+"' ";
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            seguimientoProgramaProduccionList.clear();
            rs.first();
            for(int i=0;i<rows;i++){
                SeguimientoProgramaProduccion bean=new SeguimientoProgramaProduccion();
                bean.setCodSeguimientoPrograma(rs.getString(1));
                bean.setHorasHombre(rs.getDouble(2));
                bean.setHorasMaquina(rs.getDouble(3));
                String fechaAux[]=rs.getString(4).split(" ");
                fechaAux=fechaAux[0].split("-");
                //bean.setFechaInicio(fechaAux[2]+"/"+fechaAux[1]+"/"+fechaAux[0]);
                fechaAux=rs.getString(5).split(" ");
                fechaAux=fechaAux[0].split("-");
                //bean.setFechaFinal(fechaAux[2]+"/"+fechaAux[1]+"/"+fechaAux[0]);
                bean.setHoraInicio(rs.getString(6));
                bean.setHoraFinal(rs.getString(7));
                bean.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINA"));
                bean.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                seguimientoProgramaProduccionList.add(bean);
                rs.next();
            }            
            if(rs!=null){
                rs.close();
                st.close();
            }
            codActividad= this.obtieneCodActividad();
            this.cargarMaquinarias();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String obtieneCodActividad(){
        String codigoActividad="";
        try {
            String sql="select APPR.COD_ACTIVIDAD FROM ACTIVIDADES_PROGRAMA_PRODUCCION APPR   " ;
            sql+=" where APPR.COD_ACTIVIDAD_PROGRAMA='"+codigo+"' ";            
            System.out.println("cargar cod_actividad:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            if(rs.next()){
                codigoActividad = rs.getString("COD_ACTIVIDAD");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codigoActividad;
    }

    public String cargarNombreComProd(){
        try {
            setCon(Util.openConnection(getCon()));
            String sql=" select cp.nombre_prod_semiterminado";
            sql+=" from COMPONENTES_PROD cp,PRODUCTOS p,FORMULA_MAESTRA fm";
            sql+=" where cp.COD_COMPPROD=fm.COD_COMPPROD and p.cod_prod=cp.COD_PROD";
            sql+=" and fm.COD_FORMULA_MAESTRA='"+getCodigoFormulaMaestra()+"'";
            System.out.println("sql:-----------:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                setNombreComProd(rs.getString(1));
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("nombreComProd:"+getNombreComProd());
        return  "";
    }
    public String Guardar(){
        clearActividadesFormulaMaesra();
        return"actionAgregarSeguimientoPrograma";
    }
    public String clearActividadesFormulaMaesra(){
        SeguimientoProgramaProduccion e=new SeguimientoProgramaProduccion();
        seguimientoProgramaProduccionbean=e;
        return "";
    }
    
    public void cargarMaquinarias(){
        try {
            maquinariasSeguimientoProgramaProduccionList.clear();
            setCon(Util.openConnection(getCon()));
            String sql=" SELECT M.COD_MAQUINA, M.NOMBRE_MAQUINA " +
                    " FROM FORMULA_MAESTRA FM INNER JOIN ACTIVIDADES_FORMULA_MAESTRA AFM  " +
                    " ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA INNER JOIN MAQUINARIA_ACTIVIDADES_FORMULA MAF " +
                    " ON MAF.COD_ACTIVIDAD_FORMULA = AFM.COD_ACTIVIDAD_FORMULA INNER JOIN MAQUINARIAS M ON MAF.COD_MAQUINA = M.COD_MAQUINA " +
                    " WHERE FM.COD_COMPPROD ="+codigoCompProd+"  AND FM.COD_FORMULA_MAESTRA = '"+codigoFormulaMaestra+"'  AND AFM.COD_ACTIVIDAD = '"+codActividad+"'" ;
            
            System.out.println("select cargarProductos:"+sql);
            ResultSet rs=null;
            
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
                if(rs.next()){
                    maquinariasSeguimientoProgramaProduccionList.add(new SelectItem(rs.getString("COD_MAQUINA"),rs.getString("NOMBRE_MAQUINA")));
                }            
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String Cancelar(){
        
        return "navegadorSeguimientoPrograma";
    }
    public String getCodigoSeguimientoPrograma(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select MAX(s.COD_SEGUIMIENTO_PROGRAMA)+1 from SEGUIMIENTO_PROGRAMA_PRODUCCION s";
            PreparedStatement st=getCon().prepareStatement(sql);
            System.out.println("sql:MAX:"+sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
            
            seguimientoProgramaProduccionbean.setCodSeguimientoPrograma(codigo);
            System.out.println("coiogogo:"+codigo);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
    public String guardarActividadesFormulaMaestra(){
        try {
            
            getCodigoSeguimientoPrograma();
//            String fechaInicio[]=seguimientoProgramaProduccionbean.getFechaInicio().split("/");
//            seguimientoProgramaProduccionbean.setFechaInicio(fechaInicio[2]+"/"+fechaInicio[1]+"/"+fechaInicio[0]);
//
//            String fechaFinal[]=seguimientoProgramaProduccionbean.getFechaFinal().split("/");
//            seguimientoProgramaProduccionbean.setFechaFinal(fechaFinal[2]+"/"+fechaFinal[1]+"/"+fechaFinal[0]);
            
            String sql="insert into SEGUIMIENTO_PROGRAMA_PRODUCCION(COD_SEGUIMIENTO_PROGRAMA,COD_PROGRAMA_PROD,COD_COMPPROD,COD_FORMULA_MAESTRA,COD_LOTE_PRODUCCION,";
            sql+=" COD_ACTIVIDAD_PROGRAMA,HORAS_HOMBRE,HORAS_MAQUINA,FECHA_INICIO,FECHA_FINAL,HORA_INICIO,HORA_FINAL,COD_MAQUINA)values(";
            sql+="'"+seguimientoProgramaProduccionbean.getCodSeguimientoPrograma()+"','"+codigoProgramaProd+"','"+codigoCompProd+"','"+codigoFormulaMaestra+"','"+codigoLoteProd+"',";
            sql+="'"+codigo+"','"+seguimientoProgramaProduccionbean.getHorasHombre()+"','"+seguimientoProgramaProduccionbean.getHorasMaquina()+"',";
            sql+="'"+seguimientoProgramaProduccionbean.getFechaInicio()+"','"+seguimientoProgramaProduccionbean.getFechaFinal()+"',";
            sql+="'"+seguimientoProgramaProduccionbean.getHoraInicio()+"','"+seguimientoProgramaProduccionbean.getHoraFinal()+"','"+seguimientoProgramaProduccionbean.getMaquinaria().getCodMaquina()+"')";
            System.out.println("inset:"+sql);
            setCon(Util.openConnection(getCon()));
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        cargarSeguimientoProgramaProduccion();
        clearActividadesFormulaMaesra();
        return "navegadorSeguimientoPrograma";
    }
    public String actionEditar(){
        //cargarMaquinaria("",null);
        //seguimientoProgramaProduccionList.clear();
        Iterator i=seguimientoProgramaProduccionList.iterator();
        while (i.hasNext()){
            SeguimientoProgramaProduccion bean=(SeguimientoProgramaProduccion)i.next();
            if(bean.getChecked().booleanValue()){
                seguimientoProgramaProduccionbean=bean;
                this.cargarMaquinarias();
            }
            
        }
        return "actionEditarSeguimientoPrograma";
    }
    
    public String modificarSeguimientoPrograma(){
        try {
//            String fechaInicio[]=seguimientoProgramaProduccionbean.getFechaInicio().split("/");
//            seguimientoProgramaProduccionbean.setFechaInicio(fechaInicio[2]+"/"+fechaInicio[1]+"/"+fechaInicio[0]);
//
//            String fechaFinal[]=seguimientoProgramaProduccionbean.getFechaFinal().split("/");
//            seguimientoProgramaProduccionbean.setFechaFinal(fechaFinal[2]+"/"+fechaFinal[1]+"/"+fechaFinal[0]);
            
            setCon(Util.openConnection(getCon()));
            String  sql="update SEGUIMIENTO_PROGRAMA_PRODUCCION set";
            sql+=" HORAS_HOMBRE='"+seguimientoProgramaProduccionbean.getHorasHombre()+"',";
            sql+=" HORAS_MAQUINA='"+seguimientoProgramaProduccionbean.getHorasMaquina()+"',";
            sql+=" FECHA_INICIO='"+seguimientoProgramaProduccionbean.getFechaInicio()+"',";
            sql+=" FECHA_FINAL='"+seguimientoProgramaProduccionbean.getFechaFinal()+"',";
            sql+=" HORA_INICIO='"+seguimientoProgramaProduccionbean.getHoraInicio()+"',";
            sql+=" HORA_FINAL='"+seguimientoProgramaProduccionbean.getHoraFinal()+"'," +
                 " COD_MAQUINA= " + seguimientoProgramaProduccionbean.getMaquinaria().getCodMaquina()+ " ";
            sql+=" where COD_SEGUIMIENTO_PROGRAMA="+seguimientoProgramaProduccionbean.getCodSeguimientoPrograma();
            System.out.println("modifi:"+sql);
            PreparedStatement st=getCon().prepareStatement(sql);
            int result=st.executeUpdate();
            
            cargarSeguimientoProgramaProduccion();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return "navegadorSeguimientoPrograma";
    }
        public String eliminarSeguimientoPrograma(){
        try {
    
            Iterator i=seguimientoProgramaProduccionList.iterator();
            int result=0;
            while (i.hasNext()){
                SeguimientoProgramaProduccion bean=(SeguimientoProgramaProduccion)i.next();
                if(bean.getChecked().booleanValue()){
                    String sql="delete from SEGUIMIENTO_PROGRAMA_PRODUCCION  ";
                    sql+=" where COD_SEGUIMIENTO_PROGRAMA="+bean.getCodSeguimientoPrograma();;
                    System.out.println("delete SEGUIMIENTO_PROGRAMA_PRODUCCION:sql:"+sql);
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    result=result+st.executeUpdate(sql);
                }
            }
    
            if(result>0){
                cargarSeguimientoProgramaProduccion();
            }
    
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorSeguimientoPrograma";
    }
    public void cargarSeguimientoProgramaProduccion1(ProgramaProduccion programaProduccion){
        try {
            /* and ap.COD_TIPO_ACTIVIDAD_PRODUCCION = '"+codTipoActividadProduccion+"' " +
                    " order by afm.ORDEN_ACTIVIDAD asc " +
                    " */

            //con los datos standard

            setCon(Util.openConnection(getCon()));
            String consulta = " select afm.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,afm.COD_ACTIVIDAD_FORMULA,afm.ORDEN_ACTIVIDAD ,( select sum(spp.HORAS_HOMBRE)from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD =sppr.cod_programa_prod and spp.COD_LOTE_PRODUCCION = sppr.cod_lote_produccion and spp.COD_COMPPROD = sppr.cod_compprod and spp.COD_FORMULA_MAESTRA = sppr.cod_formula_maestra and spp.COD_TIPO_PROGRAMA_PROD = sppr.cod_tipo_programa_prod and spp.COD_ACTIVIDAD_PROGRAMA = sppr.cod_actividad_programa ) HORAS_HOMBRE,sppr.HORAS_MAQUINA,sppr.FECHA_INICIO,sppr.FECHA_FINAL,sppr.COD_MAQUINA,m.NOMBRE_MAQUINA," +
                    " maf.HORAS_HOMBRE HORAS_HOMBRE_STD,       maf.HORAS_MAQUINA HORAS_MAQUINA_STD,sppr.NO_APLICA_SEGUIMIENTO " +
                            ",afm.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                    " from ACTIVIDADES_FORMULA_MAESTRA afm  " +
                    " left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=afm.COD_ESTADO_REGISTRO"+
                    " inner join ACTIVIDADES_PRODUCCION ap on afm.COD_ACTIVIDAD = ap.COD_ACTIVIDAD " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA " +
                    " left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA " +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA " +
                    " and sppr.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                    " and sppr.COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod() +"'  " +
                    " and sppr.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA  " +
                    " and sppr.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' " +
                    " and sppr.COD_TIPO_PROGRAMA_PROD in(0,'"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"') " + //and sppr.COD_TIPO_PROGRAMA_PROD = '0'
                    " left outer join maquinarias m on m.cod_maquina = sppr.cod_maquina " +
                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA " +
                    " and maf.COD_MAQUINA =sppr.COD_MAQUINA " +
                    " where afm.COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' "+
                    " and afm.COD_AREA_EMPRESA in("+codAreaEmpresa+")";
                    if(codAreaEmpresa.equals("96"))
                    {
                        consulta+=" and afm.COD_TIPO_PROGRAMA_PROD in (0,"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+")";
                    }
                    else
                    {
                        consulta+=" and afm.COD_TIPO_PROGRAMA_PROD =0 ";
                    }
                    if(codAreaEmpresa.equals("84"))
                    {
                        consulta+=" and afm.cod_presentacion = '"+programaProduccion.getPresentacionesProducto().getCodPresentacion()+"'";
                    }
                    else
                    {
                        consulta+=" and afm.COD_PRESENTACION =0 ";
                    }
                    consulta+=" and (afm.cod_estado_registro = 1 or sppr.HORAS_HOMBRE>0)"+
                              " order by afm.COD_TIPO_PROGRAMA_PROD,afm.ORDEN_ACTIVIDAD,afm.COD_ESTADO_REGISTRO  asc ";

            System.out.println("consulta cargar actividades " + consulta);
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            seguimientoProgramaProduccionList.clear();
            while(rs.next()){
                SeguimientoProgramaProduccion seguimientoProgramaProduccion = new SeguimientoProgramaProduccion();
                seguimientoProgramaProduccion.setHabilitado(true);
                seguimientoProgramaProduccion.setChecked(rs.getInt("no_aplica_seguimiento")==1?true:false);
                seguimientoProgramaProduccion.getActividadesProduccion().setCodActividad(rs.getInt("COD_ACTIVIDAD"));
                seguimientoProgramaProduccion.getActividadesProduccion().setNombreActividad(rs.getString("NOMBRE_ACTIVIDAD"));
                seguimientoProgramaProduccion.getActividadesProduccion().getEstadoReferencial().setCodEstadoRegistro(rs.getString("COD_ESTADO_REGISTRO"));
                seguimientoProgramaProduccion.getActividadesProduccion().getEstadoReferencial().setNombreEstadoRegistro(rs.getString("NOMBRE_ESTADO_REGISTRO"));
                seguimientoProgramaProduccion.getActividadesFormulaMaestra().setCodActividadFormula(rs.getInt("COD_ACTIVIDAD_FORMULA"));
                seguimientoProgramaProduccion.getActividadesFormulaMaestra().setOrdenActividad(rs.getInt("ORDEN_ACTIVIDAD"));
                seguimientoProgramaProduccion.setHorasHombre(rs.getDouble("HORAS_HOMBRE"));
                seguimientoProgramaProduccion.setHorasMaquina(rs.getDouble("HORAS_MAQUINA"));
                seguimientoProgramaProduccion.setFechaInicio(rs.getDate("FECHA_INICIO")==null?new Date():rs.getDate("FECHA_INICIO"));
                seguimientoProgramaProduccion.setFechaFinal(rs.getDate("FECHA_FINAL")==null?new Date():rs.getDate("FECHA_FINAL"));
                seguimientoProgramaProduccion.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINA")==null?"0":rs.getString("COD_MAQUINA"));
                seguimientoProgramaProduccion.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA")==null?"-NINGUNO-":rs.getString("NOMBRE_MAQUINA"));
                seguimientoProgramaProduccion.getActividadesProduccion().getTiposActividadProduccion().setCodTipoActividadProduccion(Integer.valueOf(codAreaEmpresa));

                seguimientoProgramaProduccion.getMaquinariaList().add(new SelectItem(seguimientoProgramaProduccion.getMaquinaria().getCodMaquina() ,seguimientoProgramaProduccion.getMaquinaria().getNombreMaquina()));
                seguimientoProgramaProduccion.getMaquinariaActividadesFormula().setHorasHombre(rs.getFloat("HORAS_HOMBRE_STD"));
                seguimientoProgramaProduccion.getMaquinariaActividadesFormula().setHorasMaquina(rs.getFloat("HORAS_MAQUINA_STD"));
                seguimientoProgramaProduccion.setProgramaProduccion(programaProduccion);
                //valida la deshabilacion de la actividad de pesaje
                System.out.println("en la iteracion");
                if(seguimientoProgramaProduccion.getActividadesProduccion().getCodActividad()==76 && seguimientoProgramaProduccion.getHorasHombre()>0){
                    System.out.println("en la iteracion 1");
                    seguimientoProgramaProduccion.setHabilitado(false);
                }
                if(seguimientoProgramaProduccion.getActividadesProduccion().getCodActividad()==186 && seguimientoProgramaProduccion.getHorasHombre()>0){
                    seguimientoProgramaProduccion.setHabilitado(false);
                }
                seguimientoProgramaProduccionList.add(seguimientoProgramaProduccion);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }        
    }
    public String presentacionesProducto_change(){
        this.cargarSeguimientoProgramaProduccion1(programaProduccion);
        return null;
    }
    public List cargarPresentacionesProducto(){
        List presentacionProductoList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            String consulta = " select prp.cod_presentacion,prp.NOMBRE_PRODUCTO_PRESENTACION from PRESENTACIONES_PRODUCTO prp inner join COMPONENTES_PRESPROD c on c.COD_PRESENTACION = prp.cod_presentacion " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = c.COD_COMPPROD" +
                    " where fm.COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' ";
            System.out.println("consulta"+consulta);
            Statement st= con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            presentacionProductoList.add(new SelectItem("0","-NINGUNO-"));
            while(rs.next()){
                presentacionProductoList.add(new SelectItem(rs.getString("cod_presentacion"),rs.getString("NOMBRE_PRODUCTO_PRESENTACION")));
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return presentacionProductoList;
    }
    public String getCargarContenidoSeguimientoProgramaProduccion1()
    {
        ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
        Map<String, Object> sessionMap = externalContext.getSessionMap();
        programaProduccion=(ProgramaProduccion)sessionMap.get("programaProduccion");
        codAreaEmpresa = sessionMap.get("codAreaEmpresa").toString();
        this.cargarSeguimientoProgramaProduccion1(programaProduccion);
        personalList = this.cargarPersonal(programaProduccion);
        if(codAreaEmpresa.equals("84") )//|| codAreaEmpresa.equals("75") || codAreaEmpresa.equals("40")
        {
            this.cargarDefectosEnvase();
        }
         
         
         headerColumns.clear();
         defectosEnvaseLoteList.clear();
         //<editor-fold desc="cargando area empresa registro tiempos" defaultstate="collapsed">
         try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ae.NOMBRE_AREA_EMPRESA");
                                        consulta.append(" from AREAS_EMPRESA ae");
                                        consulta.append(" where ae.COD_AREA_EMPRESA in (").append(codAreaEmpresa).append(")");
            System.out.println(" cargar area registro tiempos "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            nombreAreaEmpresaTiempo="";
            while (res.next()) 
            {
                if(nombreAreaEmpresaTiempo.length()>0)nombreAreaEmpresaTiempo+=",";
                nombreAreaEmpresaTiempo+=res.getString("NOMBRE_AREA_EMPRESA");
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        } 
        //</editor-fold>

        return null;
    }
    public String actualizarSeguimientoProgramaProduccion_action(){
        
        try {
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            //result=result+st.executeUpdate(sql);
            //para el seguimiento que tiene cod tipo actividad 0

            String consulta = " DELETE FROM " +
                        " SEGUIMIENTO_PROGRAMA_PRODUCCION " +
                        " WHERE COD_COMPPROD ='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                        " AND COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                        " AND COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' " +
                        " AND COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                        " AND COD_TIPO_PROGRAMA_PROD in(0, '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"')  " +
                        " AND COD_ACTIVIDAD_PROGRAMA IN( SELECT AFM.COD_ACTIVIDAD_FORMULA  " +
                        " FROM ACTIVIDADES_FORMULA_MAESTRA AFM  " +
                        " INNER JOIN ACTIVIDADES_PRODUCCION APR ON APR.COD_ACTIVIDAD = AFM.COD_ACTIVIDAD " +
                        " WHERE AFM.COD_ACTIVIDAD_FORMULA = COD_ACTIVIDAD_PROGRAMA  " +
                        " AND AFM.COD_AREA_EMPRESA in("+codAreaEmpresa+") and isnull(AFM.COD_PRESENTACION,0)='"+codPresentacion+"') ";
            
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            //Iterator i = seguimientoProgramaProduccionList.iterator();
            //programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()
            // se asigna cero si el tipo de actividad de programa de produccion es 1 : produccion

            String codTipoProgramaProd = codAreaEmpresa.equals("96")?"0":programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd();
            Iterator i = seguimientoProgramaProduccionList.iterator();
            while(i.hasNext()){
                SeguimientoProgramaProduccion seguimientoProgramaProduccion = (SeguimientoProgramaProduccion)i.next();
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD, " +
                        "  COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,   COD_ACTIVIDAD_PROGRAMA,   FECHA_INICIO,   FECHA_FINAL,  " +
                        "  COD_MAQUINA,  HORAS_MAQUINA,  HORAS_HOMBRE," +
                        "  COD_TIPO_PROGRAMA_PROD,NO_APLICA_SEGUIMIENTO) " +
                        "  VALUES ( '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' , " +
                        "  '"+programaProduccion.getCodProgramaProduccion()+"',  " +
                        "  '"+programaProduccion.getCodLoteProduccion()+"',  " +
                        "  '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' ," +
                        "   '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula() +"' , " +
                        "  '"+sdf.format(seguimientoProgramaProduccion.getFechaInicio())+"', " +
                        "  '"+sdf.format(seguimientoProgramaProduccion.getFechaFinal())+"',  " +
                        "  '"+seguimientoProgramaProduccion.getMaquinaria().getCodMaquina()+"', '"+seguimientoProgramaProduccion.getHorasMaquina()+"'," +
                        "  '"+seguimientoProgramaProduccion.getHorasHombre()+"', '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"','"+(seguimientoProgramaProduccion.getChecked()==true?1:0)+"'); ";
                System.out.println("consulta " + consulta);
                st.executeUpdate(consulta);
                /*if((seguimientoProgramaProduccion.getActividadesProduccion().getCodActividad().equals("76")||seguimientoProgramaProduccion.getActividadesProduccion().getCodActividad().equals("186"))
                        && (seguimientoProgramaProduccion.getHorasHombre()>0 || seguimientoProgramaProduccion.getHorasMaquina()>0)){
                    consulta = "  UPDATE PROGRAMA_PRODUCCION  SET COD_ESTADO_PROGRAMA = 7 " +
                               " WHERE COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' "+
                               " AND COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod() +"' " +
                               " AND COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'  " +
                               " AND COD_LOTE_PRODUCCION= '"+programaProduccion.getCodLoteProduccion()+"' " +
                               " AND COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                               " AND COD_ESTADO_PROGRAMA<>6  ";
                    System.out.println("consulta " + consulta);
                    st.executeUpdate(consulta);
                }*/
                //control del proceso 18 limpieza para blisteado
//                if(seguimientoProgramaProduccion.getActividadesProduccion().getCodActividad().equals("18")){
//                    codTipoProgramaProd = programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd();
//                }
            }
            
           setMensaje("");
            if(!verificarExisteRegistroSolicitudSalidaES(programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod(),programaProduccion.getCodLoteProduccion()))
            {
                if(verificarRegistrarAreaEmpresaSolicitud(codAreaEmpresa,programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()))
                {

                   int codActividad=Integer.valueOf(this.codActividadAreaEmpresa(codAreaEmpresa,programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()));
                    System.out.println("cod actividad "+codActividad);
                   if(codActividad==0)
                   {
                       setMensaje("2");
                   }
                   else
                   {
                        Iterator e = seguimientoProgramaProduccionList.iterator();
                        while(e.hasNext()){
                            SeguimientoProgramaProduccion seguimientoProgramaProduccion1 = (SeguimientoProgramaProduccion)e.next();

                            if(seguimientoProgramaProduccion1.getActividadesProduccion().getCodActividad()==codActividad)
                            {
                                if(seguimientoProgramaProduccion1.getHorasHombre()>0)
                                {

                                   setMensaje("1");
                                }
                            }
                        }
                   }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String cancelarRegistroSeguimientoProgramaProduccion_action(){
        try {
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String,Object> session = externalContext.getSessionMap();
            this.redireccionar(session.get("url").toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String llenarMaquinarias(){
        try {
            System.out.println("entro al evento llenar maquinarias");
            SeguimientoProgramaProduccion seguimientoProgramaProduccion = (SeguimientoProgramaProduccion)seguimientoProgramaProduccionDataTable.getRowData();
            if(seguimientoProgramaProduccion.getCheckedMaquinaria().booleanValue()==true && seguimientoProgramaProduccion.getMaquinariaList().size()<=1){
                setCon(Util.openConnection(getCon()));
                Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA " +
                        " from MAQUINARIA_ACTIVIDADES_FORMULA maf " +
                        " inner join MAQUINARIAS m on m.COD_MAQUINA = maf.COD_MAQUINA " +
                        " where maf.COD_ACTIVIDAD_FORMULA = '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"'  ";
                System.out.println("consulta " + consulta);                
                ResultSet rs = st.executeQuery(consulta);
                seguimientoProgramaProduccion.getMaquinariaList().clear();
                seguimientoProgramaProduccion.getMaquinariaList().add(new SelectItem("0", "-NINGUNO-"));
                while(rs.next()){
                    seguimientoProgramaProduccion.getMaquinariaList().add(new SelectItem(rs.getString("COD_MAQUINA"), rs.getString("NOMBRE_MAQUINA")));
                }
                rs.close();
                st.close();
            }
            
            
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void verificaProcesoPesaje1(ActividadesSeguimientoProgramaProduccion actividadesSeguimientoProgramaProduccion){
       try {
            if(actividadesSeguimientoProgramaProduccion.getActividadesFormulaMaestra().getActividadesProduccion().getCodActividad()==76
                    && (actividadesSeguimientoProgramaProduccion.getSeguimientoProgramaProduccion().getHorasHombre()>0 ||
                        actividadesSeguimientoProgramaProduccion.getSeguimientoProgramaProduccion().getHorasMaquina()>0)){
                String consulta = " UPDATE PROGRAMA_PRODUCCION  SET COD_ESTADO_PROGRAMA = 7 WHERE COD_PROGRAMA_PROD = '" + codigoProgramaProd +"'"+
                    " AND COD_COMPPROD ='"+codigoCompProd+"' AND COD_FORMULA_MAESTRA ='"+codigoFormulaMaestra+"' AND COD_LOTE_PRODUCCION='"+codigoLoteProd+"' " +
                    " AND COD_ESTADO_PROGRAMA<>6 ";
                System.out.println("consulta cambio estado programa produccion " + consulta);

                setCon(Util.openConnection(getCon()));
                Statement st = con.createStatement();
                st.executeUpdate(consulta);
            }
       } catch (Exception e) {
           e.printStackTrace();
       }
   }
    public String maquinaria_change(){
        try {
            SeguimientoProgramaProduccion seguimientoProgramaProduccion = (SeguimientoProgramaProduccion) seguimientoProgramaProduccionDataTable.getRowData();
            String consulta = " select maf.HORAS_HOMBRE,maf.HORAS_MAQUINA " +
                    " from MAQUINARIA_ACTIVIDADES_FORMULA maf " +
                    " where maf.COD_ACTIVIDAD_FORMULA = '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"' " +
                    " and maf.COD_MAQUINA = '"+seguimientoProgramaProduccion.getMaquinaria().getCodMaquina()+"' ";
            System.out.println("consulta " + consulta);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            seguimientoProgramaProduccion.getMaquinariaActividadesFormula().setHorasHombre(0);
            seguimientoProgramaProduccion.getMaquinariaActividadesFormula().setHorasMaquina(0);
            if(rs.next()){
                seguimientoProgramaProduccion.getMaquinariaActividadesFormula().setHorasHombre(rs.getFloat("HORAS_HOMBRE"));
                seguimientoProgramaProduccion.getMaquinariaActividadesFormula().setHorasMaquina(rs.getFloat("HORAS_MAQUINA"));
            }
            rs.close();
            st.close();


            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verSeguimientoProgramaProduccionPersonal_action(){
        seguimientoProgramaProduccion = (SeguimientoProgramaProduccion) seguimientoProgramaProduccionDataTable.getRowData();
        this.cargarDetalleSeguimientoProgramaProduccionPersonal(seguimientoProgramaProduccion);        
        return null;
    }
    public void cargarDetalleSeguimientoProgramaProduccionPersonal(SeguimientoProgramaProduccion seguimientoProgramaProduccion){
        try {

            String consulta = " select spprp.HORAS_EXTRA,spprp.COD_PERSONAL,p.NOMBRE_PILA,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,spprp.HORAS_HOMBRE,spprp.UNIDADES_PRODUCIDAS,spprp.FECHA_INICIO,spprp.FECHA_FINAL" +
                    " ,ISNULL(spprp.UNIDADES_PRODUCIDAS_EXTRA,0) AS unidadesExtra " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spprp left outer join personal p on p.COD_PERSONAL = spprp.COD_PERSONAL " +
                    " where spprp.COD_PROGRAMA_PROD = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and spprp.COD_COMPPROD = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                    " and spprp.COD_ACTIVIDAD_PROGRAMA = '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"' " +
                    " and spprp.COD_FORMULA_MAESTRA = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                    " and spprp.COD_LOTE_PRODUCCION = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"'" +
                    " and spprp.COD_TIPO_PROGRAMA_PROD ='"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"' "; //order by spprp.fecha_inicio asc
            System.out.println("consulta " + consulta);
            Connection con  = null;
            con=Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().clear();
            while(rs.next()){
                SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal = new SeguimientoProgramaProduccionPersonal();
                seguimientoProgramaProduccionPersonal.getPersonal().setCodPersonal(rs.getString("cod_personal"));
                seguimientoProgramaProduccionPersonal.getPersonal().setNombrePersonal(rs.getString("nombre_pila"));
                seguimientoProgramaProduccionPersonal.getPersonal().setApPaternoPersonal(rs.getString("ap_paterno_personal"));
                seguimientoProgramaProduccionPersonal.getPersonal().setApMaternoPersonal(rs.getString("ap_materno_personal"));
                seguimientoProgramaProduccionPersonal.setHorasHombre(rs.getDouble("horas_hombre"));
                seguimientoProgramaProduccionPersonal.setUnidadesProducidas(rs.getInt("unidades_producidas"));
                seguimientoProgramaProduccionPersonal.setFechaInicio(rs.getTimestamp("fecha_inicio")==null?new Date():rs.getTimestamp("fecha_inicio"));
                seguimientoProgramaProduccionPersonal.setFechaFinal(rs.getTimestamp("fecha_final")==null?new Date():rs.getTimestamp("fecha_final"));
                seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().add(seguimientoProgramaProduccionPersonal);
                seguimientoProgramaProduccionPersonal.setHoraInicio(rs.getTimestamp("fecha_inicio")==null?new Date():rs.getTimestamp("fecha_inicio"));
                seguimientoProgramaProduccionPersonal.setHoraFinal(rs.getTimestamp("fecha_final")==null?new Date():rs.getTimestamp("fecha_final"));
                seguimientoProgramaProduccionPersonal.setHorasExtra(rs.getDouble("HORAS_EXTRA"));
                seguimientoProgramaProduccionPersonal.setUnidadesProducidasExtra(rs.getDouble("unidadesExtra"));
            }
            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String adicionarPersonal_action(){

            //validacion para el registro de seguimiento
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            Iterator i = seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().iterator();
            System.out.println("$$seguimiento mas inicio lote"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion());
            while(i.hasNext()){
                SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal = (SeguimientoProgramaProduccionPersonal) i.next();
                seguimientoProgramaProduccionPersonal.getFechaInicio().setHours(seguimientoProgramaProduccionPersonal.getHoraInicio().getHours());
                seguimientoProgramaProduccionPersonal.getFechaInicio().setMinutes(seguimientoProgramaProduccionPersonal.getHoraInicio().getMinutes());
                seguimientoProgramaProduccionPersonal.getFechaFinal().setHours(seguimientoProgramaProduccionPersonal.getHoraFinal().getHours());
                seguimientoProgramaProduccionPersonal.getFechaFinal().setMinutes(seguimientoProgramaProduccionPersonal.getHoraFinal().getMinutes());
                System.out.println("$$seguimiento INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                        "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                        "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA) VALUES ( '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                        "'"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"','"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"'," +
                        "'"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"','"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"'," +
                        " '"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                        " '"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"','"+seguimientoProgramaProduccionPersonal.getHorasHombre()+"','"+seguimientoProgramaProduccionPersonal.getUnidadesProducidas()+"'" +
                        ",'"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaRegistro())+"','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaInicio())+"','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaFinal())+"'" +
                        ",'"+seguimientoProgramaProduccionPersonal.getHorasExtra()+"','"+seguimientoProgramaProduccionPersonal.getUnidadesProducidasExtra()+"') ");
            }
            System.out.println("$$seguimiento mas final");

        try {
            seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().add(new SeguimientoProgramaProduccionPersonal());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarPersonal_action(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        System.out.println("$$seguimiento menos inicio lote "+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion());
        try {
            Iterator i = seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().iterator();
            List seguimientoProgramaProduccionPersonalList1 = new ArrayList();
            while(i.hasNext()){
                 SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal=(SeguimientoProgramaProduccionPersonal)i.next();
                if(seguimientoProgramaProduccionPersonal.getChecked().booleanValue()==false){
                    seguimientoProgramaProduccionPersonalList1.add(seguimientoProgramaProduccionPersonal);
                    
                    seguimientoProgramaProduccionPersonal.getFechaInicio().setHours(seguimientoProgramaProduccionPersonal.getHoraInicio().getHours());
                    seguimientoProgramaProduccionPersonal.getFechaInicio().setMinutes(seguimientoProgramaProduccionPersonal.getHoraInicio().getMinutes());
                    seguimientoProgramaProduccionPersonal.getFechaFinal().setHours(seguimientoProgramaProduccionPersonal.getHoraFinal().getHours());
                    seguimientoProgramaProduccionPersonal.getFechaFinal().setMinutes(seguimientoProgramaProduccionPersonal.getHoraFinal().getMinutes());
                     System.out.println("$$seguimiento INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                        "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                        "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA) VALUES ( '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                        "'"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"','"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"'," +
                        "'"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"','"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"'," +
                        " '"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                        " '"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"','"+seguimientoProgramaProduccionPersonal.getHorasHombre()+"','"+seguimientoProgramaProduccionPersonal.getUnidadesProducidas()+"'" +
                        ",'"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaRegistro())+"','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaInicio())+"','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaFinal())+"'" +
                        ",'"+seguimientoProgramaProduccionPersonal.getHorasExtra()+"','"+seguimientoProgramaProduccionPersonal.getUnidadesProducidasExtra()+"') ");
                }
            }
        System.out.println("$$seguimiento menos final");
            seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().clear();
            seguimientoProgramaProduccion.setSeguimientoProgramaProduccionPersonalList(seguimientoProgramaProduccionPersonalList1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String registrarSeguimientoProgramaProduccionPersonal_action(){
        seguimientoProgramaProduccionPersonal = new SeguimientoProgramaProduccionPersonal();
        DateTime fechaInicial = new DateTime(seguimientoProgramaProduccionPersonal.getFechaInicio());
        fechaInicial = fechaInicial.withSecondOfMinute(0);
        DateTime fechaFinal = new DateTime(seguimientoProgramaProduccionPersonal.getFechaFinal());
        fechaFinal = fechaFinal.withSecondOfMinute(0);
        seguimientoProgramaProduccionPersonal.setFechaFinal(fechaFinal.toDate());
        seguimientoProgramaProduccionPersonalEditar.setFechaInicio(fechaInicial.toDate());
        //personalList = this.personalArea(personalList, seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList());
        return null;
    }
    public String guardarSeguimientoProgramaProduccionPersonal_action(){
        try {
            mensaje="";
            ManagedProgramaProduccion managedProgramaProduccion = new ManagedProgramaProduccion();
            //this.fechas_change();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            String consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL(COD_COMPPROD,COD_PROGRAMA_PROD, COD_LOTE_PRODUCCION," +
                    " COD_FORMULA_MAESTRA,  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE," +
                    "  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,fecha_inicio,fecha_final) VALUES (" +
                    "  '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                    "  '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"'," +
                    " '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"'," +
                    " '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'," +
                    " '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"'," +
                    "  '"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                    " '"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"'," +
                    " '"+managedProgramaProduccion.redondear(seguimientoProgramaProduccionPersonal.getHorasHombre(),2)+"','"+seguimientoProgramaProduccionPersonal.getUnidadesProducidas()+"','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaRegistro())+"','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaInicio())+"','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaFinal())+"'); ";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con=Util.openConnection(con);
            Statement st = con.createStatement();
            st.executeUpdate(consulta);
            //this.verSeguimientoProgramaProduccionPersonal_action();
            this.cargarDetalleSeguimientoProgramaProduccionPersonal(seguimientoProgramaProduccion);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String fechas_change(){
        DateTime fechaInicial = new DateTime(seguimientoProgramaProduccionPersonal.getFechaInicio());
        DateTime fechaFinal = new DateTime(seguimientoProgramaProduccionPersonal.getFechaFinal());
//        Interval interval = new Interval(fechaInicial,fechaFinal);
//        interval.getEndMillis();
//        Duration duration = new Duration(fechaInicial,fechaFinal);
//
//        //Hours hours = Hours.h.
//        Period period = new Period(fechaInicial,fechaFinal);
        //seguimientoProgramaProduccionPersonal.setHorasHombre(Double.parseDouble(String.valueOf((period.getDays()*24)+period.getHours()+(Float.parseFloat(String.valueOf(period.getMinutes()))/60.0))));
        //System.out.println("el periodo"+period.getDays()+" "+period.getHours()+" "+(period.getMinutes()/60.0) + " "+ duration.toString());
        System.out.println("el periodo" + (fechaFinal.getMillis()-fechaInicial.getMillis()));
        seguimientoProgramaProduccionPersonal.setHorasHombre(Double.parseDouble(String.valueOf((fechaFinal.getMillis()-fechaInicial.getMillis())/3600000.0)));
        return null;
    }
    public String fechas_change1(){
        SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal1 = (SeguimientoProgramaProduccionPersonal) seguimientoProgramaProduccionPersonalDataTable.getRowData();
        seguimientoProgramaProduccionPersonal1.getFechaInicio().setHours(seguimientoProgramaProduccionPersonal1.getHoraInicio().getHours());
        seguimientoProgramaProduccionPersonal1.getFechaInicio().setMinutes(seguimientoProgramaProduccionPersonal1.getHoraInicio().getMinutes());
        seguimientoProgramaProduccionPersonal1.getFechaFinal().setHours(seguimientoProgramaProduccionPersonal1.getHoraFinal().getHours());
        seguimientoProgramaProduccionPersonal1.getFechaFinal().setMinutes(seguimientoProgramaProduccionPersonal1.getHoraFinal().getMinutes());
        DateTime fechaInicial = new DateTime(seguimientoProgramaProduccionPersonal1.getFechaInicio());
        DateTime fechaFinal = new DateTime(seguimientoProgramaProduccionPersonal1.getFechaFinal());
//        Interval interval = new Interval(fechaInicial,fechaFinal);
//        interval.getEndMillis();
//        Duration duration = new Duration(fechaInicial,fechaFinal);

//        //Hours hours = Hours.h.
//        Period period = new Period(fechaInicial,fechaFinal);
        //seguimientoProgramaProduccionPersonal.setHorasHombre(Double.parseDouble(String.valueOf((period.getDays()*24)+period.getHours()+(Float.parseFloat(String.valueOf(period.getMinutes()))/60.0))));
        //System.out.println("el periodo"+period.getDays()+" "+period.getHours()+" "+(period.getMinutes()/60.0) + " "+ duration.toString());
        System.out.println("el periodo" + (fechaFinal.getMillis()-fechaInicial.getMillis()));
        seguimientoProgramaProduccionPersonal1.setHorasHombre(Double.parseDouble(String.valueOf((fechaFinal.getMillis()-fechaInicial.getMillis())/3600000.0)));
        return null;
    }
    public String editarSeguimientoProgramaProduccionPersonal_action(){
        try {
            Iterator i = seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().iterator();
            while(i.hasNext()){
                seguimientoProgramaProduccionPersonal = (SeguimientoProgramaProduccionPersonal) i.next();
                if(seguimientoProgramaProduccionPersonal.getChecked().booleanValue()==true){
                    break;
                }
            }
            seguimientoProgramaProduccionPersonalEditar.setFechaInicio(seguimientoProgramaProduccionPersonal.getFechaInicio());
            seguimientoProgramaProduccionPersonalEditar.setFechaFinal(seguimientoProgramaProduccionPersonal.getFechaFinal());
            seguimientoProgramaProduccionPersonalEditar.getPersonal().setCodPersonal(seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal());



        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void copiarLista(List lista1, List lista2){
        Iterator i = lista1.iterator();
        int i1 = 0;
        while(i.hasNext()){
            SeguimientoProgramaProduccionPersonal s = (SeguimientoProgramaProduccionPersonal)i.next();
            s.setDescr(String.valueOf(i1));
            i1++;
            lista2.add(s);
        }
    }
    public String guardarSeguimientoProgramaProduccionPersonal2_action(){
        try {
            mensaje = "";


        int conSobreescrituraTiempos = 0;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
            SimpleDateFormat dias=new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat horas=new SimpleDateFormat("HH:mm");
            List auxList = new ArrayList();
        
            this.copiarLista(seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList(), auxList);
            Iterator ii =seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().iterator();
            while(ii.hasNext()){

                SeguimientoProgramaProduccionPersonal s = (SeguimientoProgramaProduccionPersonal) ii.next();
                
                Iterator ii1 = auxList.iterator();
                System.out.println("xxxx1");
                while(ii1.hasNext()){
                    SeguimientoProgramaProduccionPersonal s1 = (SeguimientoProgramaProduccionPersonal) ii1.next();
                    DateTime dtInicio = new DateTime(s.getHoraInicio());
                    DateTime dtFinal = new DateTime(s.getHoraFinal());
                    DateTime dt1Inicio = new DateTime(s1.getHoraInicio());
                    DateTime dt1Final = new DateTime(s1.getHoraFinal());
                    dtFinal.getMillis();
                    if(dias.format(s.getFechaInicio()).equals(dias.format(s1.getFechaInicio()))
                            && s1.getPersonal().getCodPersonal().equals(s.getPersonal().getCodPersonal())
                            && (dt1Inicio.getMillis()<=dtInicio.getMillis() &&  dtInicio.getMillis()<=dt1Final.getMillis() ||
                                dt1Inicio.getMillis()<=dtFinal.getMillis() && dtFinal.getMillis()<=dt1Final.getMillis() ||
                                dtInicio.getMillis()<=dt1Inicio.getMillis() && dt1Inicio.getMillis()<= dtFinal.getMillis() ||
                                dtInicio.getMillis()<=dt1Final.getMillis() && dt1Final.getMillis() <=dtFinal.getMillis()
                                )
                            && !s.getDescr().equals(s1.getDescr())){
                        System.out.println(dtInicio.getMillis() + " " + dtFinal.getMillis()  + " " + dt1Inicio.getMillis() + " "  + dt1Final.getMillis());
                        mensaje = " Existe sobreescritura de tiempos, verifique el registro de tiempos ";
                        System.out.println(mensaje);
                        conSobreescrituraTiempos = 1;
                        break;
                        //return null;
                    }

                }
            }

            if(conSobreescrituraTiempos == 1){
                return null;
            }
            this.guardarSeguimientoProgramaProduccionPersonal1_action();
            } catch (Exception e) {
                e.printStackTrace();
        }
        return null;
    }
    public String guardarSeguimientoProgramaProduccionPersonal1_action()throws SQLException
    {
        mensaje = "";
        
        Connection con = null;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
            SimpleDateFormat dias=new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat horas=new SimpleDateFormat("HH:mm");
            
        try {
            

            double totalHoras = 0.0;
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            
            String consulta = " delete from seguimiento_programa_produccion_personal where cod_programa_prod = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " and cod_lote_produccion = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"'" +
                    " and cod_compprod = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                    " and cod_formula_maestra = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                    " and cod_tipo_programa_prod = '"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    " and cod_actividad_programa = '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"'";
            System.out.println("consulta " + consulta );
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
            Iterator i = seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().iterator();
            int cont = 1;
            Date fechaInicio = null;
            Date fechaFinal = null;
            System.out.println("$$seguimiento guardar inicio lote "+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion());
            while(i.hasNext()){
                SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal = (SeguimientoProgramaProduccionPersonal) i.next();
                seguimientoProgramaProduccionPersonal.getFechaInicio().setHours(seguimientoProgramaProduccionPersonal.getHoraInicio().getHours());
                seguimientoProgramaProduccionPersonal.getFechaInicio().setMinutes(seguimientoProgramaProduccionPersonal.getHoraInicio().getMinutes());

                seguimientoProgramaProduccionPersonal.getFechaFinal().setDate(seguimientoProgramaProduccionPersonal.getFechaInicio().getDate());
                seguimientoProgramaProduccionPersonal.getFechaFinal().setMonth(seguimientoProgramaProduccionPersonal.getFechaInicio().getMonth());
                seguimientoProgramaProduccionPersonal.getFechaFinal().setYear(seguimientoProgramaProduccionPersonal.getFechaInicio().getYear());
                seguimientoProgramaProduccionPersonal.getFechaFinal().setHours(seguimientoProgramaProduccionPersonal.getHoraFinal().getHours());
                seguimientoProgramaProduccionPersonal.getFechaFinal().setMinutes(seguimientoProgramaProduccionPersonal.getHoraFinal().getMinutes());
                System.out.println("fecha inicio "+seguimientoProgramaProduccionPersonal.getHoraInicio());
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                        "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                        "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA) VALUES ( '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'," +
                        "'"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"','"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"'," +
                        "'"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"','"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"'," +
                        " '"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'," +
                        " '"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"','"+seguimientoProgramaProduccionPersonal.getHorasHombre()+"','"+seguimientoProgramaProduccionPersonal.getUnidadesProducidas()+"'" +
                        ",'"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaRegistro())+":00','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaInicio())+":00','"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaFinal())+":00'" +
                        ",'"+seguimientoProgramaProduccionPersonal.getHorasExtra()+"','"+seguimientoProgramaProduccionPersonal.getUnidadesProducidasExtra()+"'); ";
                System.out.println("$$seguimiento " + consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
                totalHoras = totalHoras + seguimientoProgramaProduccionPersonal.getHorasHombre();
                if(fechaInicio==null ||seguimientoProgramaProduccionPersonal.getFechaInicio().compareTo(fechaInicio)>0){fechaInicio = seguimientoProgramaProduccionPersonal.getFechaInicio();}
                if(fechaFinal==null || seguimientoProgramaProduccionPersonal.getFechaFinal().compareTo(fechaFinal)<0){fechaFinal = seguimientoProgramaProduccionPersonal.getFechaFinal();}
            }
            System.out.println("$$seguimiento guardar final ");
                if(fechaInicio!=null &&fechaFinal!=null)
                {
                    seguimientoProgramaProduccion.setFechaInicio(fechaInicio);
                    seguimientoProgramaProduccion.setFechaFinal(fechaInicio);
                    consulta = " update seguimiento_programa_produccion set fecha_inicio = '"+sdf.format(seguimientoProgramaProduccion.getFechaInicio())+":00'," +
                            " fecha_final='"+sdf.format(seguimientoProgramaProduccion.getFechaFinal())+":00',horas_hombre = '"+totalHoras+"' where " +
                            " cod_programa_prod='"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"' and cod_compprod = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and cod_formula_maestra = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                            " and cod_lote_produccion = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"' and cod_tipo_programa_prod ='"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"' and cod_actividad_programa = '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"' ";
                    System.out.println("consulta update actividad" + consulta);
                    seguimientoProgramaProduccion.setHorasHombre(totalHoras);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)
                    {
                        System.out.println("se actualizo");
                    }
                    else
                    {
                        consulta=" INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD, " +
                                "  COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,   COD_ACTIVIDAD_PROGRAMA,   FECHA_INICIO,   FECHA_FINAL,  " +
                                "  COD_MAQUINA,  HORAS_MAQUINA,  HORAS_HOMBRE," +
                                "  COD_TIPO_PROGRAMA_PROD) " +
                                "  VALUES ( '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' , " +
                                "  '"+programaProduccion.getCodProgramaProduccion()+"',  " +
                                "  '"+programaProduccion.getCodLoteProduccion()+"',  " +
                                "  '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' ," +
                                "   '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula() +"' , " +
                                "  '"+sdf.format(seguimientoProgramaProduccion.getFechaInicio())+":00', " +
                                "  '"+sdf.format(seguimientoProgramaProduccion.getFechaFinal())+":00',  " +
                                "  '"+seguimientoProgramaProduccion.getMaquinaria().getCodMaquina()+"', '"+seguimientoProgramaProduccion.getHorasMaquina()+"'," +
                                "  '"+seguimientoProgramaProduccion.getHorasHombre()+"', '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"')";
                        System.out.println("consulta insert "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
                    }
             }
             /*if(seguimientoProgramaProduccion.getActividadesProduccion().getCodActividad().equals("96"))
             {
                 consulta="DELETE DEFECTOS_ENVASE_PROGRAMA_PRODUCCION  WHERE " +
                         " cod_lote_produccion='"+programaProduccion.getCodLoteProduccion()+"' and COD_TIPO_PROGRAMA_PROD='"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' and "+
                     " CAST(COD_PERSONAL AS varchar)+' '+cast(COD_TIPO_PROGRAMA_PROD as varchar)"+
                     " +' '+cast(COD_PROGRAMA_PROD as varchar)+' '+cast(COD_FORMULA_MAESTRA as varchar)"+
                     " +' '+cast(COD_LOTE_PRODUCCION as varchar)+' '+cast(COD_COMPPROD as varchar)"+
                     " +' '+cast(COD_ACTIVIDAD_PROGRAMA as varchar) not in ("+
                     " select cast(sppp.COD_PERSONAL as varchar)+' '+cast(sppp.COD_TIPO_PROGRAMA_PROD as varchar)"+
                     " +' '+cast(sppp.COD_PROGRAMA_PROD as varchar)+' '+cast(sppp.COD_FORMULA_MAESTRA as varchar)"+
                     " +' '+cast(sppp.COD_LOTE_PRODUCCION as varchar)+' '+cast(sppp.COD_COMPPROD as varchar) "+
                     " +' '+cast(sppp.COD_ACTIVIDAD_PROGRAMA as varchar)"+
                     " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp" +
                     " where sppp.COD_LOTE_PRODUCCION='"+programaProduccion.getCodLoteProduccion()+"' and sppp.COD_TIPO_PROGRAMA_PROD='"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' )" ;
                     
                      
                System.out.println("consulta delete defectos de usuarios no registrados si hubiera "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se eliminaron los registro innecesarios ");
                
                }*/
            con.commit();
            mensaje = "registro realizado correctamente";
            pst.close();
            con.close();
        } catch (Exception e) {
            mensaje="Ocurrio un problema la momento de registrar los datos,intente de nuevo";
            con.rollback();
            e.printStackTrace();
        }
        finally
        {
            con.close();
        }
        //Util.redireccionar("navegador_actividades_programa.jsf");
        return null;
    }
    public String cancelarSeguimientoProgramaProduccionPersonal_action(){
        mensaje="";
        Util.redireccionar("navegador_actividades_programa.jsf");
        return null;
    }
    public String guardarEditarSeguimientoProgramaProduccion_action(){
        try {
            ManagedProgramaProduccion managedProgramaProduccion = new ManagedProgramaProduccion();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            String consulta = " UPDATE SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL  SET" +
                    " COD_PERSONAL = '"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"', " +
                    " HORAS_HOMBRE = '"+managedProgramaProduccion.redondear(seguimientoProgramaProduccionPersonal.getHorasHombre(), 2)+"', " +
                    " UNIDADES_PRODUCIDAS = '"+seguimientoProgramaProduccionPersonal.getUnidadesProducidas()+"', " +
                    " FECHA_REGISTRO = '"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaRegistro())+"', " +
                    " FECHA_INICIO = '"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaInicio())+"'," +
                    " FECHA_FINAL = '"+sdf.format(seguimientoProgramaProduccionPersonal.getFechaFinal())+"' " +
                    " WHERE " +
                    " COD_COMPPROD ='"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and  COD_PROGRAMA_PROD = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"' and " +
                    " COD_LOTE_PRODUCCION = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"' and COD_FORMULA_MAESTRA = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"' and COD_ACTIVIDAD_PROGRAMA = '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"' and " +
                    " COD_TIPO_PROGRAMA_PROD = '"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    " and convert(varchar(20),fecha_inicio,111)+' '+convert(varchar(20),fecha_inicio,108) = '"+sdf.format(seguimientoProgramaProduccionPersonalEditar.getFechaInicio())+"' and convert(varchar(20),fecha_final,111)+' '+convert(varchar(20),fecha_final,108) = '"+sdf.format(seguimientoProgramaProduccionPersonalEditar.getFechaFinal())+"' and cod_personal = '"+seguimientoProgramaProduccionPersonalEditar.getPersonal().getCodPersonal()+"' ;";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            st.executeUpdate(consulta);
            this.cargarDetalleSeguimientoProgramaProduccionPersonal(seguimientoProgramaProduccion);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarSeguimientoProgramaProduccionPersonal_action(){
        try {
            Iterator i = seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().iterator();
            SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal = new SeguimientoProgramaProduccionPersonal();
            while(i.hasNext()){
                 seguimientoProgramaProduccionPersonal= (SeguimientoProgramaProduccionPersonal) i.next();
                if(seguimientoProgramaProduccionPersonal.getChecked().booleanValue()==true){
                    break;
                }
            }
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " DELETE FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL WHERE COD_PROGRAMA_PROD = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodProgramaProduccion()+"'" +
                    " AND COD_COMPPROD = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                    " AND COD_FORMULA_MAESTRA = '"+seguimientoProgramaProduccion.getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()+"'" +
                    " AND COD_LOTE_PRODUCCION = '"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"'" +
                    " AND COD_TIPO_PROGRAMA_PROD = '"+seguimientoProgramaProduccion.getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    " AND COD_PERSONAL = '"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"'" +
                    " AND COD_ACTIVIDAD_PROGRAMA = '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"' ";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            //this.verSeguimientoProgramaProduccionPersonal_action();
            this.cargarDetalleSeguimientoProgramaProduccionPersonal(seguimientoProgramaProduccion);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public List personalArea(List personalList,List seguimientoProgramaProduccionPersonalList){
        List personalAreaList = new ArrayList();
        Iterator i = seguimientoProgramaProduccionPersonalList.iterator();
        while(i.hasNext()){
            SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal = (SeguimientoProgramaProduccionPersonal)i.next();
            Iterator i1 = personalList.iterator();
            while(i1.hasNext()){
                SelectItem selectItem = (SelectItem)i1.next();
                if(!selectItem.getValue().toString().equals(seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal())){
                    personalAreaList.add(selectItem);
                }
            }
        }
        return personalAreaList;
    }
    public List cargarPersonalAreaActividad(ProgramaProduccion programaProduccion){
        List personalList = new ArrayList();
        try {
            String consulta =" select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from  personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL " +
                    " where pa.cod_area_empresa in ("+codAreaEmpresa+")" +
                    " AND p.COD_ESTADO_PERSONA=1 and p.COD_AREA_EMPRESA in(select a.COD_AREA_EMPRESA from AREAS_EMPRESA a where a.DIVISION = 3) " +
                    " union select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from  personal_temporal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL " +
                    " where pa.cod_area_empresa in ("+codAreaEmpresa+")" +
                    " AND p.COD_ESTADO_PERSONA=1  " +
                    " union  select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from personal p where p.cod_area_empresa  in ("+codAreaEmpresa+") and p.COD_ESTADO_PERSONA=1 order by NOMBRES_PERSONAL" +
                    "    ";
            
            System.out.println("consulta area actividad" + consulta);
            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            personalList.clear();
            rs = st.executeQuery(consulta);
            personalList.add(new SelectItem("0","-NINGUNO-"));
            while (rs.next()) {
                personalList.add(new SelectItem(rs.getString("COD_PERSONAL"), rs.getString("NOMBRES_PERSONAL")));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return personalList;
    }
    public List cargarPersonalAreaActividadProducto(ProgramaProduccion programaProduccion){
        List personalList = new ArrayList();
        try {
            String consulta =" select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from  personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL " +
                    " where pa.cod_area_empresa in ('"+programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"')" +
                    " AND p.COD_ESTADO_PERSONA=1 and p.COD_AREA_EMPRESA in(select a.COD_AREA_EMPRESA from AREAS_EMPRESA a where a.DIVISION = 3) " +
                    " union select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from  personal_temporal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL " +
                    " where pa.cod_area_empresa in ('"+programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"')" +
                    " AND p.COD_ESTADO_PERSONA=1 " +
                    " union  select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from personal p where p.cod_area_empresa  in ('"+programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+"') and p.COD_ESTADO_PERSONA=1 order by NOMBRES_PERSONAL ";

            System.out.println("consulta personal area actidad producto" + consulta);
            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            personalList.clear();
            rs = st.executeQuery(consulta);
            personalList.add(new SelectItem("0","-NINGUNO-"));
            while (rs.next()) {
                personalList.add(new SelectItem(rs.getString("COD_PERSONAL"), rs.getString("NOMBRES_PERSONAL")));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return personalList;
    }
    public List cargarPersonal(ProgramaProduccion programaProduccion) {
        List personalList = new ArrayList();
        String codAreaEmpresa1 = "0";
                 
                    codAreaEmpresa1 = programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa();
                 
        try {
            String codAreaSelect=(codAreaEmpresa.equals("96")?programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa():codAreaEmpresa);
            String consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                            " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                            " where pa.cod_area_empresa in ("+codAreaSelect+") AND p.COD_ESTADO_PERSONA = 1 union "+
                            " select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal+'(temporal)') NOMBRES_PERSONAL"+
                            " from personal_temporal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                            " where pa.cod_area_empresa in ("+codAreaSelect+") AND p.COD_ESTADO_PERSONA = 1 union"+
                            " select P1.COD_PERSONAL, (P1.AP_PATERNO_PERSONAL + ' ' + P1.AP_MATERNO_PERSONAL + ' ' +"+
                            " P1.NOMBRES_PERSONAL + ' ' + P1.nombre2_personal) NOMBRES_PERSONAL"+
                            " from personal p1 where p1.cod_area_empresa in ("+codAreaSelect+") and p1.COD_ESTADO_PERSONA = 1"+
                            " order by NOMBRES_PERSONAL";
            /*String consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL)AS NOMBREpERSONAL from personal p order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";*/
            System.out.println("consulta cargar personal areas "+consulta);
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            personalList.add(new SelectItem("0","--Seleccione una opcion--"));
            while(res.next())
            {
                personalList.add(new SelectItem(res.getString(1),res.getString(2)));
            }
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return personalList;
    }
    public String aceptarSeguimientoProgramaProduccionPersonal_action(){
        Iterator i = seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().iterator();
        seguimientoProgramaProduccion.setHorasHombre(0);
        int cont = 1;
        Date fechaInicio = new Date();
        Date fechaFinal = new Date();
        while(i.hasNext()){
            SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal = (SeguimientoProgramaProduccionPersonal)i.next();
            if(cont==1){fechaInicio = seguimientoProgramaProduccionPersonal.getFechaInicio();}
            if(cont==seguimientoProgramaProduccion.getSeguimientoProgramaProduccionPersonalList().size()){fechaFinal = seguimientoProgramaProduccionPersonal.getFechaFinal();}
            seguimientoProgramaProduccion.setHorasHombre(seguimientoProgramaProduccion.getHorasHombre()+seguimientoProgramaProduccionPersonal.getHorasHombre());
            cont++;
        }
        seguimientoProgramaProduccion.setFechaInicio(fechaInicio);
        seguimientoProgramaProduccion.setFechaFinal(fechaFinal);
        return null;
    }
 /*   public String getCodigoActividadesFormulaMaestra(){
        String codigo="1";
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select max(cod_actividad_formula)+1 from actividades_formula_maestra";
            PreparedStatement st=getCon().prepareStatement(sql);
            System.out.println("sql:MAX:"+sql);
            ResultSet rs=st.executeQuery();
            while (rs.next())
                codigo=rs.getString(1);
            if(codigo==null)
                codigo="1";
  
            ActividadesFormulaMaestrabean.setCodActividadFormula(codigo);
            System.out.println("coiogogo:"+codigo);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  "";
    }
  
    public void cargarMaquinaria(String codigo,ActividadesFormulaMaestra bean){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_maquina,nombre_maquina from maquinarias where cod_estado_registro=1";
            sql+=" order by nombre_maquina";
            System.out.println("sql_maquinarias:"+sql);
            ResultSet rs=null;
  
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(!codigo.equals("")){
  
            } else{
                maquinariasList.clear();
                rs=st.executeQuery(sql);
                while (rs.next())
                    maquinariasList.add(new SelectItem(rs.getString(1),rs.getString(2)));
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
  
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void cargarActividades(){
        try {
            setCon(Util.openConnection(getCon()));
            String sql="select cod_actividad,nombre_actividad from actividades_produccion where cod_estado_registro=1";
            sql+=" and cod_actividad <> all (select f.cod_actividad from ACTIVIDADES_FORMULA_MAESTRA f where f.cod_formula_maestra='"+getCodigo()+"')";
            System.out.println("sql_actividades:"+sql);
            System.out.println("cargar:"+sql);
            setCon(Util.openConnection(getCon()));
            Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            ActividadesFormulaMaestraAdicionarList.clear();
            while (rs.next()){
                ActividadesFormulaMaestra bean=new ActividadesFormulaMaestra();
                bean.getActividadesProduccion().setCodActividad(rs.getString(1));
                bean.getActividadesProduccion().setNombreActividad(rs.getString(2));
                ActividadesFormulaMaestraAdicionarList.add(bean);
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }
  
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    /**
  * Metodo para cargar los datos en
  * el datatable
  */
    
 /*   public String Guardar(){
        clearActividadesFormulaMaesra();
        cargarActividades();
        //cargarMaquinaria("",null);
        return"actionAgregarActividadesFM";
    }*/
    
    
   /* public String actionEditar(){
        //cargarMaquinaria("",null);
        ActividadesFormulaMaestraEditarList.clear();
        Iterator i=ActividadesFormulaMaestraList.iterator();
        while (i.hasNext()){
            ActividadesFormulaMaestra bean=(ActividadesFormulaMaestra)i.next();
            if(bean.getChecked().booleanValue()){
                ActividadesFormulaMaestraEditarList.add(bean);
            }
    
        }
        return "actionEditarActividadesFM";
    }
    
    
    public void clearActividadesFormulaMaesra(){
    
        getActividadesFormulaMaestraAdicionarList().clear();
    }
    
    public String guardarActividadesFormulaMaestra(){
        try {
            Iterator i=getActividadesFormulaMaestraAdicionarList().iterator();
            while (i.hasNext()){
                ActividadesFormulaMaestra bean=(ActividadesFormulaMaestra)i.next();
                if(bean.getChecked().booleanValue()){
                    getCodigoActividadesFormulaMaestra();
                    String sql="insert into actividades_formula_maestra(cod_actividad_formula,cod_actividad,cod_formula_maestra,orden_actividad)values(";
                    sql+="'"+ActividadesFormulaMaestrabean.getCodActividadFormula()+"',";
                    sql+="'"+bean.getActividadesProduccion().getCodActividad()+"',";
                    sql+="'"+getCodigo()+"',";
                    sql+="'"+bean.getOrdenActividad()+"')";
                    System.out.println("inset:"+sql);
                    setCon(Util.openConnection(getCon()));
                    PreparedStatement st=getCon().prepareStatement(sql);
                    int result=st.executeUpdate();
                }
            }
            cargarActividadFormulaMaestra();
            clearActividadesFormulaMaesra();
    
        } catch (SQLException e) {
            e.printStackTrace();
        }
    
        return "navegadorActividadesFM";
    }
    public String modificarActividadesFormulaMaestra(){
        try {
            Iterator i=getActividadesFormulaMaestraEditarList().iterator();
            while (i.hasNext()){
                ActividadesFormulaMaestra bean=(ActividadesFormulaMaestra)i.next();
                setCon(Util.openConnection(getCon()));
                String  sql="update actividades_formula_maestra set";
                sql+=" orden_actividad='"+bean.getOrdenActividad()+"'";
                sql+=" where cod_actividad_formula="+bean.getCodActividadFormula();
                System.out.println("modifi:"+sql);
                PreparedStatement st=getCon().prepareStatement(sql);
                int result=st.executeUpdate();
            }
            cargarActividadFormulaMaestra();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    
        return "navegadorActividadesFM";
    }
    
    public String eliminarActividadesProduccion(){
        try {
    
            Iterator i=ActividadesFormulaMaestraList.iterator();
            int result=0;
            while (i.hasNext()){
                ActividadesFormulaMaestra bean=(ActividadesFormulaMaestra)i.next();
                if(bean.getChecked().booleanValue()){
                    String sql="delete from actividades_formula_maestra  ";
                    sql+=" where cod_actividad_formula="+bean.getCodActividadFormula();;
                    System.out.println("deleteActividadesFORMULA:sql:"+sql);
                    setCon(Util.openConnection(getCon()));
                    Statement st=getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    result=result+st.executeUpdate(sql);
                }
            }
    
            if(result>0){
                cargarActividadFormulaMaestra();
            }
    
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "navegadorActividadesFM";
    }
    public String Cancelar(){
        ActividadesFormulaMaestraList.clear();
        cargarActividadFormulaMaestra();
        return "navegadorActividadesFM";
    }
    
    */
    
//Metodo que cierra la conexion
    private boolean verificarRegistrarAreaEmpresaSolicitud(String codAreaEmpresaActividad,String codCompProd)
    {
        boolean existeActividad=false;
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            String consulta="select top 1 * from CONFIGURACION_SOLICITUDES_MATERIALES csm where "+
                            " csm.COD_AREA_EMPRESA_ACTIVIDAD in ('"+codAreaEmpresaActividad+"') and csm.COD_AREA_EMPRESA_PRODUCTO in "+
                            "(select cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp where cp.COD_COMPPROD='"+codCompProd+"')";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            System.out.println("consulta verificar actividad procesos "+consulta);
            ResultSet res=st.executeQuery(consulta);
            existeActividad=res.next();
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return existeActividad;
    }
    private String codActividadAreaEmpresa(String codAreaEmpresaActividad,String codCompProd)
    {
        String codActividad="0";
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            String consulta="select csm.COD_ACTIVIDAD from CONFIGURACION_SOLICITUDES_MATERIALES csm where "+
                            " csm.COD_AREA_EMPRESA_ACTIVIDAD in ('"+codAreaEmpresaActividad+"') and csm.COD_ACTIVIDAD in(";
            Iterator e = seguimientoProgramaProduccionList.iterator();
            if(e.hasNext())
            {
                SeguimientoProgramaProduccion seguimientoProgramaProduccion1 = (SeguimientoProgramaProduccion)e.next();
                consulta+=seguimientoProgramaProduccion1.getActividadesProduccion().getCodActividad();
            }
            while(e.hasNext())
            {
                SeguimientoProgramaProduccion seguimientoProgramaProduccion1 = (SeguimientoProgramaProduccion)e.next();
                consulta+=","+seguimientoProgramaProduccion1.getActividadesProduccion().getCodActividad();
            }
            consulta+=") and csm.COD_AREA_EMPRESA_PRODUCTO in "+
                            " ( select cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp where cp.COD_COMPPROD='"+codCompProd+"')";
            System.out.println("consulta verificar registro actividad para producto "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                codActividad=res.getString("COD_ACTIVIDAD");
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return codActividad;
    }
    private boolean verificarExisteRegistroSolicitudSalidaES(String codCompProd,String codLoteProduccion)
    {
        boolean existe=false;
        String consulta="SELECT TOP 1 * FROM SOLICITUDES_SALIDA ss inner join SOLICITUDES_SALIDA_DETALLE ssd"+
                        " on ss.COD_FORM_SALIDA=ssd.COD_FORM_SALIDA where ss.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'"+
                        " and ss.COD_COMPPROD='"+codCompProd+"' and ssd.COD_MATERIAL in (select fmdes.COD_MATERIAL"+
                        " from FORMULA_MAESTRA fm inner join FORMULA_MAESTRA_DETALLE_ES fmdes"+
                        " on fm.COD_FORMULA_MAESTRA=fmdes.COD_FORMULA_MAESTRA "+
                        " and fm.COD_COMPPROD=ss.COD_COMPPROD)";
        System.out.println("con verificar solicitud de salida "+consulta);
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            existe=res.next();
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return existe;
    }
    public double redondear(double numero, int decimales ) {
        return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
    }
    public String generarSolicitudAutomaticaES()
    {
       try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta="select ISNULL(MAX(ss.COD_FORM_SALIDA),0)+1 as cod from SOLICITUDES_SALIDA ss";
                    ResultSet res=st.executeQuery(consulta);
                    int codFormSalida=0;
                    if(res.next())
                    {
                        codFormSalida=res.getInt("cod");
                    }
                    consulta="select cp.RENDIMIENTO_PRODUCTO from COMPONENTES_PROD cp where cp.COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
                    System.out.println("consulta rendimiento "+consulta);
                    res=st.executeQuery(consulta);
                    double rendimiento=0d;
                    if(res.next())
                    {
                        rendimiento=res.getDouble("RENDIMIENTO_PRODUCTO");
                    }
                    //corregir y relacionar con el rendimiento por producto

                    consulta="select tae.PORCIENTO_TOLERANCIA from TOLERANCIA_AREAS_EMPRESA tae where tae.COD_AREA_EMPRESA in ("+
                             " select cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp where cp.COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"')";
                    consulta = " select rendimiento_producto from componentes_prod c where c.cod_compprod = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
                    System.out.println("consulta buscar tolerancia area "+consulta);
                    double tolerancia=0d;
                    res=st.executeQuery(consulta);
                    if(res.next())
                    {
                       tolerancia=res.getDouble("rendimiento_producto");
                    }
                    System.out.println(" tolerancia "+tolerancia+" rendimi "+rendimiento+" cant lote "+programaProduccion.getCantidadLote()+" cant form "+programaProduccion.getFormulaMaestra().getCantidadLote());

                    ManagedAccesoSistema usuario = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
                    SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm");
                     consulta="INSERT INTO SOLICITUDES_SALIDA(  COD_GESTION,  COD_FORM_SALIDA,  COD_TIPO_SALIDA_ALMACEN,  COD_ESTADO_SOLICITUD_SALIDA_ALMACEN," +
                        "  SOLICITANTE,  AREA_DESTINO_SALIDA,  FECHA_SOLICITUD,  COD_LOTE_PRODUCCION,  OBS_SOLICITUD,  ESTADO_SISTEMA," +
                        "  CONTROL_CALIDAD,  COD_INGRESO_ALMACEN,  COD_ALMACEN,  orden_trabajo,cod_compprod,cod_presentacion,COD_LUGAR_ACOND,SOLICITUD_AUTOMATICA_PRODUCCION) " +
                        "VALUES ((select top 1 g.COD_GESTION  from GESTIONES g where g.GESTION_ESTADO=1),'"+codFormSalida+"','2','5','"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"','84','"+sdf.format(new Date())+"',"+
                        "'"+programaProduccion.getCodLoteProduccion()+"','salida automatica ES',1,0,0,'2','','"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"','0','',1)";
                     System.out.println("consulta insert solicitud "+consulta);
                    PreparedStatement pst=con1.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se inserto la cabecera de la solicitud");
                    consulta="select distinct mt.COD_MATERIAL, mt.NOMBRE_MATERIAL,   um.COD_UNIDAD_MEDIDA,   um.NOMBRE_UNIDAD_MEDIDA,    fmdes.CANTIDAD CANTIDAD," +
                    "  prp.cod_presentacion,       prp.NOMBRE_PRODUCTO_PRESENTACION,       um.abreviatura" +
                    " from PROGRAMA_PRODUCCION pprd     inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = pprd.COD_COMPPROD     " +
                    " inner join FORMULA_MAESTRA_DETALLE_ES fmdes on fmdes.COD_FORMULA_MAESTRA =     fm.COD_FORMULA_MAESTRA" +
                    " inner join materiales mt on mt.COD_MATERIAL = fmdes.COD_MATERIAL     inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =  fmdes.COD_UNIDAD_MEDIDA" +
                    " inner join COMPONENTES_PRESPROD cprp on cprp.COD_COMPPROD = fm.COD_COMPPROD  and cprp.COD_TIPO_PROGRAMA_PROD = pprd.COD_TIPO_PROGRAMA_PROD" +
                    " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion =    fmdes.COD_PRESENTACION_PRODUCTO and prp.cod_presentacion =  cprp.COD_PRESENTACION " +
                    " where fm.COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                            " and pprd.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                            " and pprd.COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                            " and pprd.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' " +
                            " and  pprd.COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'";
                    System.out.println("consulta buscar materiales ES "+consulta);
                    res=st.executeQuery(consulta);
                    double cantidad=0d;
                    while(res.next())
                    {
                        cantidad=res.getDouble("CANTIDAD");
                        rendimiento=(rendimiento>0?rendimiento:(programaProduccion.getCantidadLote()/programaProduccion.getFormulaMaestra().getCantidadLote()));
                        cantidad=cantidad*rendimiento;
                        if(tolerancia>0)
                        {
                            cantidad=cantidad+(cantidad*tolerancia);
                        }
                        cantidad=redondear(cantidad,0);

                        consulta="INSERT INTO SOLICITUDES_SALIDA_DETALLE(  COD_FORM_SALIDA,  COD_MATERIAL,  CANTIDAD,  CANTIDAD_ENTREGADA," +
                            "  COD_UNIDAD_MEDIDA) VALUES ('"+codFormSalida+"','"+res.getString("COD_MATERIAL")+"'," +
                            "'"+(cantidad>0?cantidad:1)+"',0,'"+res.getString("COD_UNIDAD_MEDIDA")+"')";
                        System.out.println("consulta insert solicitud detalle "+consulta);
                        pst=con1.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se inserto el detalle");
                    }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();

        }
        return null;
    }
    private void cargarOperariosArea(String codAreaEmpresa)//codCompProd
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
//            String consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
//                            " from PERSONAL p where p.COD_AREA_EMPRESA in (select DISTINCT cp.COD_AREA_EMPRESA  from COMPONENTES_PROD cp where cp.COD_COMPPROD='"+codCompProd+"')"+
//                            " and p.COD_ESTADO_PERSONA=1 order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
            String consulta = "  select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  nombrePersonal" +
                    " from  personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL " +
                    " where pa.cod_area_empresa in ('"+codAreaEmpresa+"')" +
                    " AND p.COD_ESTADO_PERSONA=1 and p.COD_AREA_EMPRESA in(select a.COD_AREA_EMPRESA from AREAS_EMPRESA a where a.DIVISION = 3) " +
                    " union select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from  personal_temporal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL " +
                    " where pa.cod_area_empresa in ('"+codAreaEmpresa+"')" +
                    " AND p.COD_ESTADO_PERSONA=1  " +
                    " union  select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+P.AP_MATERNO_PERSONAL +' ' +  P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal)  NOMBRES_PERSONAL" +
                    " from personal p where p.cod_area_empresa  in ("+codAreaEmpresa+") and p.COD_ESTADO_PERSONA=1 order by nombrePersonal ";

            System.out.println("consulta cargar operarios "+consulta);
            ResultSet res=st.executeQuery(consulta);
            personalList.clear();
            while(res.next())
            {
                personalList.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersonal")));//opearariosList
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }

    }
    private void cargarDefectosEnvase()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE"+
                            " from DEFECTOS_ENVASE de where de.COD_ESTADO_REGISTRO=1";
            ResultSet res=st.executeQuery(consulta);
            defectosEnvaseList.clear();
            while(res.next())
            {
                defectosEnvaseList.add(new SelectItem(res.getInt("COD_DEFECTO_ENVASE"),res.getString("NOMBRE_DEFECTO_ENVASE")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }


    public String adicionarDefectos_action()
    {
        seguimientoProgramaProduccionPersonal.getDefectosEnvaseProgramaProduccionList().add(new DefectosEnvaseProgramaProduccion());
        return null;
    }
    public String registrarDefectosEnvase_action()
    {
        seguimientoProgramaProduccionPersonal=(SeguimientoProgramaProduccionPersonal)seguimientoProgramaProduccionPersonalDataTable.getRowData();
        this.cargarDefectosEnvaseProgramaProduccion(seguimientoProgramaProduccionPersonal);
        Util.redireccionar("navegador_defectos_envases.jsf");
        return null;
    }

     private UIComponent createTxt(String expression) {
        FacesContext fCtx = FacesContext.getCurrentInstance();
        ELContext elCtx = fCtx.getELContext();
        ExpressionFactory ef = fCtx.getApplication().getExpressionFactory();
        ValueExpression ve = ef.createValueExpression(elCtx, expression,
                Object.class);
        HtmlOutputText txt = new HtmlOutputText();
        txt.setValueExpression("value", ve);
        return txt;
    }
     private void cargarDefectos()
     {
         String consulta="select d.COD_DEFECTO_ENVASE,d.NOMBRE_DEFECTO_ENVASE from DEFECTOS_ENVASE d where d.COD_ESTADO_REGISTRO=1 order by d.NOMBRE_DEFECTO_ENVASE";
         try
         {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            defectosEnvaseLoteList.clear();
            while(res.next())
            {
                DefectosEnvaseProgramaProduccion defecto=new DefectosEnvaseProgramaProduccion();
                defecto.getDefectoEnvase().setCodDefectoEnvase(res.getInt("COD_DEFECTO_ENVASE"));
                defecto.getDefectoEnvase().setNombreDefectoEnvase(res.getString("NOMBRE_DEFECTO_ENVASE"));
                defectosEnvaseLoteList.add(defecto);
            }
            res.close();
            st.close();
            con1.close();
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }
     }

    private void cargarDefectosEnvaseProgramaProduccion(SeguimientoProgramaProduccionPersonal seguimiento)
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
                            " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                            " inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA"+
                            " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD"+
                            " and ap.COD_ACTIVIDAD in (29,40,157) inner join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL"+
                            " where sppp.COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'"+
                            " and sppp.COD_FORMULA_MAESTRA='"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'"+
                            " and sppp.COD_LOTE_PRODUCCION='"+programaProduccion.getCodLoteProduccion()+"'"+
                            " and sppp.COD_PROGRAMA_PROD='"+programaProduccion.getCodProgramaProduccion()+"'"+
                            " and sppp.COD_TIPO_PROGRAMA_PROD='"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                            " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA" +
                            " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
            System.out.println("consulta cargar personal "+consulta);
            ResultSet res=st.executeQuery(consulta);
            defectosEnvaseLoteHtmlDataTable=new HtmlDataTable();
            headerColumns.clear();

            Statement stDetalle=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle=null;
            if(res.next())
            {
                res.last();
                res.first();
                headerColumns.add(res.getString("nombrePersonal"));
                consulta="select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,ISNULL(depp.CANTIDAD_DEFECTOS_ENCONTRADOS,0) as CANTIDAD_DEFECTOS_ENCONTRADOS"+
                         " from DEFECTOS_ENVASE de left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                         " on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE "+
                       //  " and depp.COD_ACTIVIDAD_PROGRAMA='"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"'"+
                         " and depp.COD_FORMULA_MAESTRA='"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'"+
                        " and depp.COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'"+
                        " and depp.COD_LOTE_PRODUCCION='"+programaProduccion.getCodLoteProduccion()+"'"+
                        " and depp.COD_PERSONAL='"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"'"+
                        " and depp.COD_PROGRAMA_PROD='"+programaProduccion.getCodProgramaProduccion()+"'"+
                        " and depp.COD_TIPO_PROGRAMA_PROD='"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                        " and depp.COD_PERSONAL_OPERARIO='"+res.getString("COD_PERSONAL")+"'"+
                        " and de.cod_estado_registro=1 order by de.ORDEN";
                System.out.println("consulta buscar defectos "+consulta);
                resDetalle=stDetalle.executeQuery(consulta);
                defectosEnvaseLoteList.clear();
                while(resDetalle.next())
                {
                    DefectosEnvaseProgramaProduccion bean=new DefectosEnvaseProgramaProduccion();
                    bean.getDefectoEnvase().setCodDefectoEnvase(resDetalle.getInt("COD_DEFECTO_ENVASE"));
                    bean.getDefectoEnvase().setNombreDefectoEnvase(resDetalle.getString("NOMBRE_DEFECTO_ENVASE"));
                    List<DefectosEnvasePersonal> defectosEnvasePersonalArray=new ArrayList<DefectosEnvasePersonal>();
                    DefectosEnvasePersonal nuevo=new DefectosEnvasePersonal();
                    nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                    nuevo.setCantidadDefectosEncontrados(resDetalle.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"));
                    defectosEnvasePersonalArray.add(nuevo);
                    bean.setDefectosEnvasePersonalList(defectosEnvasePersonalArray);
                    defectosEnvaseLoteList.add(bean);
                }
                resDetalle.close();
            }

            while(res.next())
            {
                headerColumns.add(res.getString("nombrePersonal"));
                consulta="select ISNULL(depp.CANTIDAD_DEFECTOS_ENCONTRADOS,0) as CANTIDAD_DEFECTOS_ENCONTRADOS"+
                         " from DEFECTOS_ENVASE de left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                         " on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE "+
                        // " and depp.COD_ACTIVIDAD_PROGRAMA='"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"'"+
                         " and depp.COD_FORMULA_MAESTRA='"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'"+
                        " and depp.COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'"+
                        " and depp.COD_LOTE_PRODUCCION='"+programaProduccion.getCodLoteProduccion()+"'"+
                        " and depp.COD_PERSONAL='"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"'"+
                        " and depp.COD_PROGRAMA_PROD='"+programaProduccion.getCodProgramaProduccion()+"'"+
                        " and depp.COD_TIPO_PROGRAMA_PROD='"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                        " and depp.COD_PERSONAL_OPERARIO='"+res.getString("COD_PERSONAL")+"'"+
                        " and de.cod_estado_registro=1 order by de.ORDEN";
                System.out.println("consulta buscar defectos "+consulta);
                resDetalle=stDetalle.executeQuery(consulta);
                int cont=0;
                while(resDetalle.next())
                {
                    DefectosEnvasePersonal nuevo=new DefectosEnvasePersonal();
                    nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                    nuevo.setCantidadDefectosEncontrados(resDetalle.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"));
                    defectosEnvaseLoteList.get(cont).getDefectosEnvasePersonalList().add(nuevo);
                    cont++;
                }
            }

            stDetalle.close();
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarRegistroDefectos_action()throws SQLException
    {
        mensaje="";
        String consulta="DELETE DEFECTOS_ENVASE_PROGRAMA_PRODUCCION WHERE "+
                        " COD_PERSONAL = '"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"' and "+
                        " COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' and "+
                        " COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' and "+
                        " COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' and "+
                        " COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' and "+
                        " COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' ";
                        //" and  COD_ACTIVIDAD_PROGRAMA = '"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"' ";
        System.out.println("consulta delete registros defectos "+consulta);
        Connection con1=null;
        try
        {
            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            PreparedStatement pst=con1.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron los registro anteriores de defectos");
            for(DefectosEnvaseProgramaProduccion current:defectosEnvaseLoteList)
            {
                for(DefectosEnvasePersonal dep:current.getDefectosEnvasePersonalList())
                {
                    if(dep.getCantidadDefectosEncontrados()>0)
                    {
                         consulta="INSERT INTO DEFECTOS_ENVASE_PROGRAMA_PRODUCCION(COD_DEFECTO_ENVASE, COD_PERSONAL"+
                                  " , COD_TIPO_PROGRAMA_PROD, COD_PROGRAMA_PROD, COD_FORMULA_MAESTRA,"+
                                  " COD_LOTE_PRODUCCION, COD_COMPPROD, COD_ACTIVIDAD_PROGRAMA,"+
                                  " CANTIDAD_DEFECTOS_ENCONTRADOS,COD_PERSONAL_OPERARIO)"+
                                  " VALUES ('"+current.getDefectoEnvase().getCodDefectoEnvase()+"'," +
                                  "'"+seguimientoProgramaProduccionPersonal.getPersonal().getCodPersonal()+"'," +
                                  "'"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',"+
                                  " '"+programaProduccion.getCodProgramaProduccion()+"', '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'," +
                                  "'"+programaProduccion.getCodLoteProduccion()+"','"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"',"+
                                  "'"+seguimientoProgramaProduccion.getActividadesFormulaMaestra().getCodActividadFormula()+"','"+dep.getCantidadDefectosEncontrados()+"'," +
                                  "'"+dep.getPersonal().getCodPersonal()+"')";
                         System.out.println("consulta insert defecto "+consulta);
                         pst=con1.prepareStatement(consulta);
                         if(pst.executeUpdate()>0)System.out.println("se registro el detalle de envase");
                         
                    }
                }
            }
            con1.commit();
            mensaje="1";
            pst.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            con1.rollback();
            ex.printStackTrace();
            mensaje="Ocurrio un problema a la hora de registrar los defectos,intente de nuevo";
        }
        finally
        {
            con1.close();
        }
        Util.redireccionar("navegador_actividades_programa_personal.jsf");
        return null;
    }
    public String cancelarDefectos_action(){
        Util.redireccionar("navegador_actividades_programa_personal.jsf");
        return null;
    }
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    //--------- added ----------
    private boolean permitidoRegistroHoras(SeguimientoProgramaProduccion seguimiento)
    {
        boolean permisoRegistro=true;
       if((Integer.valueOf(seguimiento.getActividadesProduccion().getCodActividad())==186)||
          (Integer.valueOf(seguimiento.getActividadesProduccion().getCodActividad())==76))
       {
           try
           {
                Connection con1=null;
                con1=Util.openConnection(con1);
                Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta="select * from RESULTADO_ANALISIS ra where ra.COD_LOTE='"+seguimientoProgramaProduccion.getProgramaProduccion().getCodLoteProduccion()+"'" +
                                " and ra.COD_ESTADO_RESULTADO_ANALISIS=1";
                System.out.println("consulta verificar certificado "+consulta);
                ResultSet res=st.executeQuery(consulta);
                permisoRegistro=(!res.next());
                st.close();
                con1.close();
           }
           catch(SQLException ex)
           {
               ex.printStackTrace();
               permisoRegistro=false;
           }
       }
       return permisoRegistro;
    }
    private boolean permitidoRegistroHorasPesaje(SeguimientoProgramaProduccion seguimiento)
    {
        boolean permisoRegistro=true;
        if(seguimiento.getActividadesProduccion().getCodActividad()==186&& seguimiento.getActividadesProduccion().getCodActividad()==76 ){

        System.out.println("la fecha final de periodo " + programaProduccion.getProgramaProduccionPeriodo().getFechaFinal());
        
        if((new Date()).compareTo(programaProduccion.getProgramaProduccionPeriodo().getFechaFinal())>0){
            permisoRegistro = false;
        }
        }
       
       
       return permisoRegistro;
    }

    public String verSeguimientosProgramaProduccionPersonal_action()
    {
        mensaje="";
        seguimientoProgramaProduccion = (SeguimientoProgramaProduccion) seguimientoProgramaProduccionDataTable.getRowData();
        if(permitidoRegistroHoras(seguimientoProgramaProduccion))
        {
            //Util.redireccionar("navegador_actividades_programa_personal.jsf");
            mensaje="1";
        }
        else
        {
            mensaje="No puede registrar tiempos de pesaje porque ya tiene registrado un certificado de control de calidad";
        }
        return null;
    }
    public String getCargarSeguimientoProgramaProduccionPersonal(){
        this.cargarDetalleSeguimientoProgramaProduccionPersonal(seguimientoProgramaProduccion);
        return null;
    }
    /**
     * Métodos de la Clase
     */
    
    public ActividadesProgramaProduccion getActividadesProgramaProduccionbean() {
        return actividadesProgramaProduccionbean;
    }
    
    public void setActividadesProgramaProduccionbean(ActividadesProgramaProduccion actividadesProgramaProduccionbean) {
        this.actividadesProgramaProduccionbean = actividadesProgramaProduccionbean;
    }
    
    public SeguimientoProgramaProduccion getSeguimientoProgramaProduccionbean() {
        return seguimientoProgramaProduccionbean;
    }
    
    public void setSeguimientoProgramaProduccionbean(SeguimientoProgramaProduccion seguimientoProgramaProduccionbean) {
        this.seguimientoProgramaProduccionbean = seguimientoProgramaProduccionbean;
    }
    
    public List getSeguimientoProgramaProduccionList() {
        return seguimientoProgramaProduccionList;
    }
    
    public void setSeguimientoProgramaProduccionList(List seguimientoProgramaProduccionList) {
        this.seguimientoProgramaProduccionList = seguimientoProgramaProduccionList;
    }
    
    public List getSeguimientoProgramaProduccionAdicionarList() {
        return seguimientoProgramaProduccionAdicionarList;
    }
    
    public void setSeguimientoProgramaProduccionAdicionarList(List seguimientoProgramaProduccionAdicionarList) {
        this.seguimientoProgramaProduccionAdicionarList = seguimientoProgramaProduccionAdicionarList;
    }
    
    public List getSeguimientoProgramaProduccionEditarList() {
        return seguimientoProgramaProduccionEditarList;
    }
    
    public void setSeguimientoProgramaProduccionEditarList(List seguimientoProgramaProduccionEditarList) {
        this.seguimientoProgramaProduccionEditarList = seguimientoProgramaProduccionEditarList;
    }
    
    public List getEstadoRegistro() {
        return estadoRegistro;
    }
    
    public void setEstadoRegistro(List estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
    public List getSeguimientoProgramaProduccionEliminar() {
        return seguimientoProgramaProduccionEliminar;
    }
    
    public void setSeguimientoProgramaProduccionEliminar(List seguimientoProgramaProduccionEliminar) {
        this.seguimientoProgramaProduccionEliminar = seguimientoProgramaProduccionEliminar;
    }
    
    public List getSeguimientoProgramaProduccionNoEliminar() {
        return seguimientoProgramaProduccionNoEliminar;
    }
    
    public void setSeguimientoProgramaProduccionNoEliminar(List seguimientoProgramaProduccionNoEliminar) {
        this.seguimientoProgramaProduccionNoEliminar = seguimientoProgramaProduccionNoEliminar;
    }
    
    public Connection getCon() {
        return con;
    }
    
    public void setCon(Connection con) {
        this.con = con;
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
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    public String getCodigoProgramaProd() {
        return codigoProgramaProd;
    }
    
    public void setCodigoProgramaProd(String codigoProgramaProd) {
        this.codigoProgramaProd = codigoProgramaProd;
    }
    
    public String getCodigoFormulaMaestra() {
        return codigoFormulaMaestra;
    }
    
    public void setCodigoFormulaMaestra(String codigoFormulaMaestra) {
        this.codigoFormulaMaestra = codigoFormulaMaestra;
    }
    
    public String getCodigoCompProd() {
        return codigoCompProd;
    }
    
    public void setCodigoCompProd(String codigoCompProd) {
        this.codigoCompProd = codigoCompProd;
    }
    
    public String getCodigoLoteProd() {
        return codigoLoteProd;
    }
    
    public void setCodigoLoteProd(String codigoLoteProd) {
        this.codigoLoteProd = codigoLoteProd;
    }
    
    public List getActividadesList() {
        return actividadesList;
    }
    
    public void setActividadesList(List actividadesList) {
        this.actividadesList = actividadesList;
    }
    
    public String getNombreComProd() {
        return nombreComProd;
    }
    
    public void setNombreComProd(String nombreComProd) {
        this.nombreComProd = nombreComProd;
    }

    public List getMaquinariasSeguimientoProgramaProduccionList() {
        return maquinariasSeguimientoProgramaProduccionList;
    }

    public void setMaquinariasSeguimientoProgramaProduccionList(List maquinariasSeguimientoProgramaProduccionList) {
        this.maquinariasSeguimientoProgramaProduccionList = maquinariasSeguimientoProgramaProduccionList;
    }

    public List getActividadesSeguimientoList() {
        return actividadesSeguimientoList;
    }

    public void setActividadesSeguimientoList(List actividadesSeguimientoList) {
        this.actividadesSeguimientoList = actividadesSeguimientoList;
    }

    public HtmlDataTable getSeguimientoProgramaProduccionDataTable() {
        return seguimientoProgramaProduccionDataTable;
    }

    public void setSeguimientoProgramaProduccionDataTable(HtmlDataTable seguimientoProgramaProduccionDataTable) {
        this.seguimientoProgramaProduccionDataTable = seguimientoProgramaProduccionDataTable;
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public SeguimientoProgramaProduccion getSeguimientoProgramaProduccion() {
        return seguimientoProgramaProduccion;
    }

    public void setSeguimientoProgramaProduccion(SeguimientoProgramaProduccion seguimientoProgramaProduccion) {
        this.seguimientoProgramaProduccion = seguimientoProgramaProduccion;
    }

    public List getPersonalList() {
        return personalList;
    }

    public void setPersonalList(List personalList) {
        this.personalList = personalList;
    }

    public SeguimientoProgramaProduccionPersonal getSeguimientoProgramaProduccionPersonal() {
        return seguimientoProgramaProduccionPersonal;
    }

    public void setSeguimientoProgramaProduccionPersonal(SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonal) {
        this.seguimientoProgramaProduccionPersonal = seguimientoProgramaProduccionPersonal;
    }

    public HtmlDataTable getSeguimientoProgramaProduccionPersonalDataTable() {
        return seguimientoProgramaProduccionPersonalDataTable;
    }

    public void setSeguimientoProgramaProduccionPersonalDataTable(HtmlDataTable seguimientoProgramaProduccionPersonalDataTable) {
        this.seguimientoProgramaProduccionPersonalDataTable = seguimientoProgramaProduccionPersonalDataTable;
    }

    public String getCodPresentacion() {
        return codPresentacion;
    }

    public void setCodPresentacion(String codPresentacion) {
        this.codPresentacion = codPresentacion;
    }
    
    public List getPresentacionesProductoList() {
        return presentacionesProductoList;
}

    public void setPresentacionesProductoList(List presentacionesProductoList) {
        this.presentacionesProductoList = presentacionesProductoList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<SelectItem> getDefectosEnvaseList() {
        return defectosEnvaseList;
    }

    public void setDefectosEnvaseList(List<SelectItem> defectosEnvaseList) {
        this.defectosEnvaseList = defectosEnvaseList;
    }

    public HtmlDataTable getDefectosEnvaseLoteHtmlDataTable() {
        return defectosEnvaseLoteHtmlDataTable;
    }

    public void setDefectosEnvaseLoteHtmlDataTable(HtmlDataTable defectosEnvaseLoteHtmlDataTable) {
        this.defectosEnvaseLoteHtmlDataTable = defectosEnvaseLoteHtmlDataTable;
    }

    public List<DefectosEnvaseProgramaProduccion> getDefectosEnvaseLoteList() {
        return defectosEnvaseLoteList;
    }

    public void setDefectosEnvaseLoteList(List<DefectosEnvaseProgramaProduccion> defectosEnvaseLoteList) {
        this.defectosEnvaseLoteList = defectosEnvaseLoteList;
    }

    public List<String> getHeaderColumns() {
        return headerColumns;
    }

    public void setHeaderColumns(List<String> headerColumns) {
        this.headerColumns = headerColumns;
    }

    public List<SelectItem> getOperariosList() {
        return operariosList;
    }

    public void setOperariosList(List<SelectItem> operariosList) {
        this.operariosList = operariosList;
    }

    public SeguimientoProgramaProduccionPersonal getSeguimientoProgramaProduccionPersonalEditar() {
        return seguimientoProgramaProduccionPersonalEditar;
    }

    public void setSeguimientoProgramaProduccionPersonalEditar(SeguimientoProgramaProduccionPersonal seguimientoProgramaProduccionPersonalEditar) {
        this.seguimientoProgramaProduccionPersonalEditar = seguimientoProgramaProduccionPersonalEditar;
    }

    public String getCodAreaEmpresa() {
        return codAreaEmpresa;
    }

    public void setCodAreaEmpresa(String codAreaEmpresa) {
        this.codAreaEmpresa = codAreaEmpresa;
    }

    public String getNombreAreaEmpresaTiempo() {
        return nombreAreaEmpresaTiempo;
    }

    public void setNombreAreaEmpresaTiempo(String nombreAreaEmpresaTiempo) {
        this.nombreAreaEmpresaTiempo = nombreAreaEmpresaTiempo;
    }

    
    
}
