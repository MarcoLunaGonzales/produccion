<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src="../js/general.js"></script>
    <script>
        function validarRegistro()
        {
            if(document.getElementById("form1:fechaVencRS").value !='')
            {
                
                
                        if(document.getElementById("form1:regSanitario").value=='')
                        {
                            alert('Debe registrar el nombre del registro Sanitario');
                            return false;
                        }
                        if(!parseInt(document.getElementById("form1:vidaUtil").value)>0)
                        {
                            alert('La vida Util del producto debe ser mayor a 0 ');
                            return false;
                        }
                        return true;
                 
            }
            else
                {
                    alert('Debe registrar la fecha de vencimiento del registro Sanitario');
                    return false;
                }
            return false;
        }
   </script>
</head>
<body>
    
    <a4j:form id="form1"  >
        <div style="text-align:center">
        
        <a4j:region id="regionUno">
            <div align="center">
                <h:outputText value="Editar Registro Sanitario" styleClass="outputText2" style="font-weight:bold;font-size:14;"    />
                <h:panelGrid columns="6" styleClass="panelgrid" headerClass="headerClassACliente" style="width:70%;border:1px solid #cccccc">
                    <f:facet name="header" >
                        <h:outputText value="Datos del producto" styleClass="outputText2"    />
                    </f:facet>
                    
                    <h:outputText value="Nombre Producto Semiterminado" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.nombreProdSemiterminado}" style=""/>
                    <h:outputText value="Nombre Genérico" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.nombreGenerico}" style=""/>
                    <h:outputText value="Forma Farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.forma.nombreForma}" style=""/>
                    <h:outputText value="Area Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.areasEmpresa.nombreAreaEmpresa}" style=""/>
                    <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.estadoCompProd.nombreEstadoCompProd}" style=""/>
                    <h:outputText value="Tipo Produccion" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.tipoProduccion.nombreTipoProduccion}" style=""/>
                    <h:outputText value="Color Presentación Primaria" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.coloresPresentacion.nombreColor}" style=""/>
                    <h:outputText value="Sabor" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.saboresProductos.nombreSabor}" style=""/>
                    
                </h:panelGrid>
                <h:panelGrid columns="3"styleClass="panelgrid" headerClass="headerClassACliente" style="border:1px solid #cccccc;margin-top:6px;">
                    <f:facet name="header" >
                        <h:outputText value="Datos Registro Sanitario" styleClass="outputText2"    />
                    </f:facet>
                    <h:outputText value="Registro Sanitario" styleClass="outputText2" style="font-weight:bold" />
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:inputText styleClass="inputText" size="50" value="#{ManagedComponentesProducto.componentesProdbean.regSanitario}"  id="regSanitario" />
                    <h:outputText value="Fecha de Vencimiento R.S." styleClass="outputText2" style="font-weight:bold" />
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:panelGroup>
                        <h:inputText value="#{ManagedComponentesProducto.componentesProdbean.fechaVencimientoRS}"   styleClass="outputText2"  id="fechaVencRS"  size="15" onblur="valFecha(this);" >
                            <f:convertDateTime pattern="dd/MM/yyyy"   />
                        </h:inputText>
                        <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha1" />
                        <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:fechaVencRS\" click_element_id=\"form1:imagenFecha1\"></DLCALENDAR>"  escape="false"  />
                    </h:panelGroup>
                    <h:outputText value="Vida Útil (Meses)" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:inputText styleClass="inputText" size="50" onkeypress="valNum();" value="#{ManagedComponentesProducto.componentesProdbean.vidaUtil}"  id="vidaUtil" />
                </h:panelGrid>
                <div style="margin-top:6px">
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedComponentesProducto.guardarEdicionRegistroSanitarioVersion_action}" onclick="if(validarRegistro()==false){return false;}"/>
                    <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="location='navegador_componentesProductoVersion.jsf'"/>
                </div>
                
            </div>
        </a4j:region>
    </a4j:form>
    </div>
    <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden" >
    </h:panelGroup>
    <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
</body>
</html>

</f:view>



