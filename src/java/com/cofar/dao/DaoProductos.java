/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.bean.Producto;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoProductos extends DaoBean 
{
    public DaoProductos() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    public DaoProductos(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    
    public List<SelectItem> listarSelectItem()
    {
        List<SelectItem> selectItemList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta=new StringBuilder("SELECT p.cod_prod,p.nombre_prod")
                                            .append(" FROM PRODUCTOS P ")
                                            .append(" WHERE p.cod_estado_prod =1")
                                            .append(" order by p.nombre_prod");
            LOGGER.debug("consulta productos "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                selectItemList.add(new SelectItem(res.getString("cod_prod"),res.getString("nombre_prod")));
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return selectItemList;
    }
    public boolean guardar(Producto producto)throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("---------------------------iniciando registro producto-----------");
        try{
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("INSERT INTO PRODUCTOS( nombre_prod,cod_estado_prod)")
                                            .append(" VALUES(")
                                                    .append("?,")//nombre de producto
                                                    .append(producto.getEstadoProducto().getCodEstadoProducto())
                                            .append(")");
            LOGGER.debug("consulta registrar producto "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,producto.getNombreProducto().trim());LOGGER.info("p1: "+producto.getNombreProducto().trim());
            if(pst.executeUpdate()>0)LOGGER.info("se registor el producto");
            ResultSet res = pst.getGeneratedKeys();
            res.next();
            producto.setCodProducto(res.getString(1));
            con.commit();
            guardado = true;
        }
        catch (SQLException ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (Exception ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("---------------------------termino registro producto-----------");
        return guardado;
    }
    
}
