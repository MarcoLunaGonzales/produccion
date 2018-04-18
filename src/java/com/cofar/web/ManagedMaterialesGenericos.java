/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.Materiales;
import com.cofar.bean.MaterialesGenericos;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
/**
 *
 * @author DASISAQ-
 */
public class ManagedMaterialesGenericos extends ManagedBean
{
    private Connection con;
    private String mensaje;
    private List<MaterialesGenericos> materialesGenericosList;
    private MaterialesGenericos materialesGenericosRegistrar;
    private MaterialesGenericos materialesGenericosEditar;
    // <editor-fold defaultstate="collapsed" desc="variables para asignar nombres de material generico a materiales">
    private List<Materiales> materialesList;
    private Materiales materialRegistrar;
    //</editor-fold>
    /**
     * Creates a new instance of ManagedMaterialesGenericos
     */
    
    public ManagedMaterialesGenericos() {
        LOGGER=LogManager.getRootLogger();
    }
    // <editor-fold defaultstate="collapsed" desc="para asociacion de nombre generico a material">
    public String getCargarMateriales()
    {
        this.cargarMateriales();
        return null;
    }
    private void cargarMateriales()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO,mg.COD_MATERIAL_GENERICO,isnull(mg.NOMBRE_MATERIAL_GENERICO,'') as NOMBRE_MATERIAL_GENERICO");
                                        consulta.append(" from materiales m ");
                                        consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                                        consulta.append(" inner join CAPITULOS c on c.COD_CAPITULO=g.COD_GRUPO");
                                        consulta.append(" left outer join MATERIALES_GENERICOS mg on mg.COD_MATERIAL_GENERICO=m.COD_MATERIAL_GENERICO");
                                        consulta.append(" where c.cod_capitulo=2");
                                        consulta.append(" order by m.NOMBRE_MATERIAL");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            materialesList=new ArrayList<Materiales>();
            while (res.next()) 
            {
                Materiales nuevo=new Materiales();
                nuevo.setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getGrupo().setNombreGrupo(res.getString("NOMBRE_GRUPO"));
                nuevo.getGrupo().getCapitulo().setNombreCapitulo(res.getString("NOMBRE_CAPITULO"));
                nuevo.getMaterialesGenericos().setNombreMaterialGenerico(res.getString("NOMBRE_MATERIAL_GENERICO"));
                nuevo.getMaterialesGenericos().setCodMaterialGenerico(res.getInt("COD_MATERIAL_GENERICO"));
                materialesList.add(nuevo);
                
            }
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    //</editor-fold>
    public String agregarMaterialGenerico_action()
    {
        materialesGenericosRegistrar=new MaterialesGenericos();
        return null;
    }
    public String editarMaterialGenerico_action()
    {
        for(MaterialesGenericos bean:materialesGenericosList)
        {
            if(bean.getChecked())
            {
                materialesGenericosEditar=bean;
            }
        }
        return null;
    }
    public String guardarAgregarMaterialGenerico_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO MATERIALES_GENERICOS(NOMBRE_MATERIAL_GENERICO,COD_ESTADO_REGISTRO)");
                                    consulta.append("VALUES(?,1)");
            LOGGER.debug("consulta " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,materialesGenericosRegistrar.getNombreMaterialGenerico());
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro el material "+materialesGenericosRegistrar.getNombreMaterialGenerico());
            con.commit();
            mensaje = "1";
            pst.close();
        } 
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar el material generico,intente de nuevo";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        } 
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarMaterialesGenericos();
        }
        return null;
    }
    public String eliminarMaterialGenerico_action()throws SQLException
    {
        for(MaterialesGenericos bean:materialesGenericosList)
        {
            if(bean.getChecked())
            {
                mensaje = "";
                try 
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("DELETE MATERIALES_GENERICOS");
                                              consulta.append(" WHERE COD_MATERIAL_GENERICO=").append(bean.getCodMaterialGenerico());
                    LOGGER.debug("consulta eliminar material generico" + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                    if (pst.executeUpdate() > 0) LOGGER.info("Se elimino el material generico ");
                    con.commit();
                    mensaje = "1";
                    pst.close();
                }
                catch (SQLException ex) 
                {
                    mensaje = "Ocurrio un error al momento de eliminar el material generico, intente de nuevo";
                    con.rollback();
                    LOGGER.warn(ex.getMessage());
                }
                catch (Exception ex) 
                {
                    mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
                    LOGGER.warn(ex.getMessage());
                } 
                finally 
                {
                    this.cerrarConexion(con);
                }
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarMaterialesGenericos();
        }
        return null;
    }
    public String guardarEdicionMaterialGenerico_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" UPDATE MATERIALES_GENERICOS");
                                    consulta.append(" set NOMBRE_MATERIAL_GENERICO=?");
                                    consulta.append(" ,COD_ESTADO_REGISTRO=").append(materialesGenericosEditar.getEstadoRegistro().getCodEstadoRegistro());
                                    consulta.append(" where COD_MATERIAL_GENERICO=").append(materialesGenericosEditar.getCodMaterialGenerico());
            LOGGER.debug("consulta editar material genericos" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,materialesGenericosEditar.getNombreMaterialGenerico());
            if (pst.executeUpdate() > 0) LOGGER.info("Se guardo la edicion del material generico");
            con.commit();
            mensaje = "1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la edición, intente de nuevo";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarMaterialesGenericos();
        }
        return null;
    }
    public String getCargarMaterialesGenericos()
    {
        this.cargarMaterialesGenericos();
        return null;
    }
    private void cargarMaterialesGenericos()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL_GENERICO,m.NOMBRE_MATERIAL_GENERICO,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO");
                                        consulta.append(" from MATERIALES_GENERICOS m ");
                                        consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO");
                                        consulta.append(" order by m.NOMBRE_MATERIAL_GENERICO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            materialesGenericosList=new ArrayList<MaterialesGenericos>();
            while (res.next()) 
            {
                MaterialesGenericos nuevo=new MaterialesGenericos();
                nuevo.setCodMaterialGenerico(res.getInt("COD_MATERIAL_GENERICO"));
                nuevo.setNombreMaterialGenerico(res.getString("NOMBRE_MATERIAL_GENERICO"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                materialesGenericosList.add(nuevo);
            }
            st.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<MaterialesGenericos> getMaterialesGenericosList() {
        return materialesGenericosList;
    }

    public void setMaterialesGenericosList(List<MaterialesGenericos> materialesGenericosList) {
        this.materialesGenericosList = materialesGenericosList;
    }

    public MaterialesGenericos getMaterialesGenericosRegistrar() {
        return materialesGenericosRegistrar;
    }

    public void setMaterialesGenericosRegistrar(MaterialesGenericos materialesGenericosRegistrar) {
        this.materialesGenericosRegistrar = materialesGenericosRegistrar;
    }

    public MaterialesGenericos getMaterialesGenericosEditar() {
        return materialesGenericosEditar;
    }

    public void setMaterialesGenericosEditar(MaterialesGenericos materialesGenericosEditar) {
        this.materialesGenericosEditar = materialesGenericosEditar;
    }
    
    
    
    
}
