/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;


import com.cofar.bean.PersonalTemporal;
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
import org.apache.logging.log4j.LogManager;
/**
 *
 * @author DASISAQ-
 */

public class ManagedPersonalTemporal extends ManagedBean {

    private Connection con=null;
    //private Logger logger=Logger.getLogger(ManagedPersonalTemporal.class);
    private List<PersonalTemporal> personalTemporalList=new ArrayList<PersonalTemporal>();
    private PersonalTemporal personalTemporalNuevo=new PersonalTemporal();
    private PersonalTemporal personalTemporalEditar=new PersonalTemporal();
    private List<SelectItem> areasEmpresaSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> estadosPersonalSelectList=new ArrayList<SelectItem>();
    private String mensaje="";
    private PersonalTemporal personalTemporalBuscar=new PersonalTemporal();
    /** Creates a new instance of ManagedPersonalTemporal */
    public ManagedPersonalTemporal() 
    {
        LOGGER=LogManager.getRootLogger();
       /* try
        {
             PatternLayout layout = new PatternLayout();
            String conversionPattern = "[%p] %d %c %M \n %m%n";
            layout.setConversionPattern(conversionPattern);
            DailyRollingFileAppender rollingAppender = new DailyRollingFileAppender();
            rollingAppender.setFile("D:\\app.log");
            rollingAppender.setDatePattern("'.'yyyy-MM-dd");
            rollingAppender.setLayout(layout);
            rollingAppender.activateOptions();
            logger.addAppender(rollingAppender);
            logger.debug("Cdcdcd");
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }*/
    }
    private void cargarAreasEmpresaSelect()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA ae where ae.COD_AREA_EMPRESA in (80,81,82,95,84,96,40,75,76,97,1001,102,86,103) order by ae.NOMBRE_AREA_EMPRESA";
            ResultSet res = st.executeQuery(consulta);
            areasEmpresaSelectList.clear();
            while (res.next())
            {
                areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String buscarPersonalTemporal_action()
    {
        this.cargarPersonalTemporal();
        return null;
    }
    private void cargarPersonalTemporal()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select pt.COD_PERSONAL,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL,pt.nombre2_personal,"+
                              " ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA"+
                              " from PERSONAL_TEMPORAL pt inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=pt.COD_AREA_EMPRESA" +
                              " where 1=1 "+
                              (personalTemporalBuscar.getApellidoPaterno().equals("")?"":" and pt.AP_PATERNO_PERSONAL like '%"+personalTemporalBuscar.getApellidoPaterno()+"%'")+
                              (personalTemporalBuscar.getApellidoMaterno().equals("")?"":" and pt.AP_MATERNO_PERSONAL like '%"+personalTemporalBuscar.getApellidoMaterno()+"%'")+
                              (personalTemporalBuscar.getNombrePersonal().equals("")?"":" and pt.NOMBRES_PERSONAL like '%"+personalTemporalBuscar.getNombrePersonal()+"%'")+
                              (personalTemporalBuscar.getNombre2personal().equals("")?"":" and pt.nombre2_personal like '%"+personalTemporalBuscar.getNombre2personal()+"%'")+
                              (personalTemporalBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("")||personalTemporalBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0")?"":"" +
                              " and pt.COD_AREA_EMPRESA='"+personalTemporalBuscar.getAreasEmpresa().getCodAreaEmpresa()+"'")+
                              " order by pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL,pt.nombre2_personal";
            System.out.println("consulta cargar personal "+consulta);
            ResultSet res = st.executeQuery(consulta);
            personalTemporalList.clear();
            while (res.next()) 
            {
                PersonalTemporal nuevo=new PersonalTemporal();
                nuevo.setCodPersonal(res.getInt("COD_PERSONAL"));
                nuevo.setApellidoPaterno(res.getString("AP_PATERNO_PERSONAL"));
                nuevo.setApellidoMaterno(res.getString("AP_MATERNO_PERSONAL"));
                nuevo.setNombrePersonal(res.getString("NOMBRES_PERSONAL"));
                nuevo.setNombre2personal(res.getString("nombre2_personal"));
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                personalTemporalList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    private void cargarEstadosPersonalAreaProduccion()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = " SELECT e.COD_ESTADO_PERSONAL_AREA_PRODUCCION,e.NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION"+
                              " FROM ESTADOS_PERSONAL_AREA_PRODUCCION  e order by e.NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION";
            ResultSet res = st.executeQuery(consulta);
            estadosPersonalSelectList.clear();
            while (res.next())
            {
                estadosPersonalSelectList.add(new SelectItem(res.getInt("COD_ESTADO_PERSONAL_AREA_PRODUCCION"),res.getString("NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION")));
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
    public String getCargarPersonalTemporal()
    {
        this.cargarPersonalTemporal();
        this.cargarAreasEmpresaSelect();
        return null;
    }
    public String agregarPersonalTemporal_action()
    {
        this.personalTemporalNuevo=new PersonalTemporal();
        return null;
    }
    public String editarPersonalTemporal_action()
    {
        for(PersonalTemporal bean:personalTemporalList)
        {
            if(bean.getChecked())
            {
                personalTemporalEditar=bean;
                break;
            }
        }
        return null;
    }
    public String guardarNuevoPersonalTemporal_action()throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO PERSONAL_TEMPORAL(COD_ESTADO_PERSONA,AP_PATERNO_PERSONAL, AP_MATERNO_PERSONAL, NOMBRES_PERSONAL,nombre2_personal,COD_AREA_EMPRESA)");
                                       consulta.append(" VALUES (1,");
                                            consulta.append("'").append(personalTemporalNuevo.getApellidoPaterno().toUpperCase()).append("',");
                                            consulta.append("'").append(personalTemporalNuevo.getApellidoMaterno().toUpperCase()).append("',");
                                            consulta.append("'").append(personalTemporalNuevo.getNombrePersonal().toUpperCase()).append("',");
                                            consulta.append("'").append(personalTemporalNuevo.getNombre2personal().toUpperCase()).append("',");
                                            consulta.append("'").append(personalTemporalNuevo.getAreasEmpresa().getCodAreaEmpresa()).append("'");
                                       consulta.append(")");
            LOGGER.debug("consulta " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate()>0)LOGGER.info("Se registro la transacción");
            ResultSet res=pst.getGeneratedKeys();
            int codPersonal=0;
            if(res.next())codPersonal=res.getInt(1);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            consulta = new StringBuilder("INSERT INTO PERSONAL_AREA_PRODUCCION(COD_PERSONAL, COD_AREA_EMPRESA,FECHA_INICIO, OPERARIO_GENERICO,COD_ESTADO_PERSONAL_AREA_PRODUCCION)");
                        consulta.append(" VALUES (");
                            consulta.append("'").append(codPersonal).append("',");
                            consulta.append("'").append(personalTemporalNuevo.getAreasEmpresa().getCodAreaEmpresa()).append("',");
                            consulta.append("'").append(sdf.format(new Date())).append("',");
                            consulta.append("0,1");
                        consulta.append(")");
            System.out.println("consulta insert area Produccion "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se registro el personal area ");
            con.commit();
            mensaje="1";
            pst.close();
        } 
        catch (SQLException ex) 
        {
            con.rollback();
             mensaje="Ocurrio un error al momento de guardar el personal, intente de nuevo";
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
             mensaje="Ocurrio un error al momento de guardar el personal, intente de nuevo";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarPersonalTemporal();
        }
        
       
        return null;
    }
    public String guardarEdicionPersonalTemporal_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta = "UPDATE PERSONAL_TEMPORAL SET AP_PATERNO_PERSONAL='"+personalTemporalEditar.getApellidoPaterno().toUpperCase()+"'"+
                            " , AP_MATERNO_PERSONAL='"+personalTemporalEditar.getApellidoMaterno().toUpperCase()+"'"+
                            " , NOMBRES_PERSONAL='"+personalTemporalEditar.getNombrePersonal().toUpperCase()+"'"+
                            " ,nombre2_personal='"+personalTemporalEditar.getNombre2personal().toUpperCase()+"'"+
                            " ,COD_AREA_EMPRESA='"+personalTemporalEditar.getAreasEmpresa().getCodAreaEmpresa()+"'"+
                            " where COD_PERSONAL='"+personalTemporalEditar.getCodPersonal()+"'";
            System.out.println("consulta update personal "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)System.out.println("");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            mensaje="Ocurrio un error al momento de guardar la edicion, intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarPersonalTemporal();
        }
        return null;
    }
    public String eliminarPersonalTemporal_action()throws SQLException
    {
        mensaje="";
        for(PersonalTemporal bean:personalTemporalList)
        {
            if(bean.getChecked())
            {
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    PreparedStatement pst=null;
                    String consulta = "select count(*) as contador from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s" +
                                      " where s.COD_PERSONAL='"+bean.getCodPersonal()+"'";
                    System.out.println("consulta verificar registro indirectos "+consulta);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    res.next();
                    if(res.getInt("contador")>0)
                    {
                        mensaje="No se puede eliminar el personal porque tiene tiempos indirectos registrados";
                    }
                    else
                    {
                        consulta="select count(*) as contador from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                                 " where s.COD_PERSONAL='"+bean.getCodPersonal()+"'";
                        System.out.println("consulta verificar registros directos "+consulta);
                        res=st.executeQuery(consulta);
                        res.next();
                        if(res.getInt("contador")>0)
                        {
                            mensaje="No se puede eliminar el personal porque tiene tiempos directos registrados";
                        }
                        else
                        {
                             consulta="delete PERSONAL_TEMPORAL  where COD_PERSONAL='"+bean.getCodPersonal()+"'";
                             System.out.println("consulta delete personal temporal"+consulta);
                             pst=con.prepareStatement(consulta);
                             if(pst.executeUpdate()>0)System.out.println("se elimino el personal temporal");
                             consulta="delete PERSONAL_AREA_PRODUCCION where COD_PERSONAL='"+bean.getCodPersonal()+"'";
                             System.out.println("consulta delete personal area produccion"+consulta);
                             pst=con.prepareStatement(consulta);
                             if(pst.executeUpdate()>0)System.out.println("se elimino el area personal");
                             consulta="delete PERSONAL_AREA_PRODUCCION_DETALLE where COD_PERSONAL='"+bean.getCodPersonal()+"'";
                             pst=con.prepareStatement(consulta);
                             if(pst.executeUpdate()>0)System.out.println("se elimino el detalle");
                             mensaje="1";
                        }
                    }
                    con.commit();
                    if(pst!=null)pst.close();
                    con.close();
                }
                catch (SQLException ex) {
                    mensaje="Ocurrio un error al momento de eliminar el personal temporal, intente de nuevo";
                    con.rollback();
                    con.close();
                    ex.printStackTrace();
                }
                break;
            }
        }
        return null;
    }

    public List<SelectItem> getAreasEmpresaSelectList() {
        return areasEmpresaSelectList;
    }

    public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
        this.areasEmpresaSelectList = areasEmpresaSelectList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public PersonalTemporal getPersonalTemporalEditar() {
        return personalTemporalEditar;
    }

    public void setPersonalTemporalEditar(PersonalTemporal personalTemporalEditar) {
        this.personalTemporalEditar = personalTemporalEditar;
    }

    public List<PersonalTemporal> getPersonalTemporalList() {
        return personalTemporalList;
    }

    public void setPersonalTemporalList(List<PersonalTemporal> personalTemporalList) {
        this.personalTemporalList = personalTemporalList;
    }

    public PersonalTemporal getPersonalTemporalNuevo() {
        return personalTemporalNuevo;
    }

    public void setPersonalTemporalNuevo(PersonalTemporal personalTemporalNuevo) {
        this.personalTemporalNuevo = personalTemporalNuevo;
    }

    public PersonalTemporal getPersonalTemporalBuscar() {
        return personalTemporalBuscar;
    }

    public void setPersonalTemporalBuscar(PersonalTemporal personalTemporalBuscar) {
        this.personalTemporalBuscar = personalTemporalBuscar;
    }

    

}
