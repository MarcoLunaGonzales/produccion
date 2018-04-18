<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script src="../js/general.js" type="text/javascript"></script>
            <style>
                .negrita
                {
                    font-weight:bold;
                }
            </style>
            
        </head>
        <body >

            <a4j:form id="form1"  >
                <center>
                   <h:outputText value="#{ManagedProductosDesarrollo.cargarAgregarProductoDesarrollo_action}"/>

                        <h:outputText value="Edicion de Producto Semiterminado Desarrollo" styleClass="outputText2" style="font-weight:bold;font-size:14;" />


                        <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente" style="width:70%;border:1px solid #cccccc;margin-top:9px">
                            <f:facet name="header" >
                                <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                            </f:facet>
                            <h:outputText value="Nombre Genérico" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:inputText styleClass="inputText" size="50" value="#{ManagedProductosDesarrollo.componentesProdEditar.nombreGenerico}"  id="nombreGenerico" />
                            <h:outputText value="Nombre Producto Semiterminado" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:inputText styleClass="inputText" size="50" value="#{ManagedProductosDesarrollo.componentesProdEditar.nombreProdSemiterminado}"  id="nombreProductoSemiterminado" />
                            <h:outputText value="Concentracion" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:inputText styleClass="inputText" size="50" value="#{ManagedProductosDesarrollo.componentesProdEditar.concentracionEnvasePrimario}"  id="concentracionSemiterminado" />
                            
                            <h:outputText value="Volumen Envase Primario" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:panelGroup>
                            <h:inputText styleClass="inputText" size="50" value="#{ManagedProductosDesarrollo.componentesProdEditar.cantidadVolumen}"  id="cantidadVolumen" onkeypress="valNum()" />
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.componentesProdEditar.unidadMedidaVolumen.codUnidadMedida}" id="codUnidadVolumen" >
                                <f:selectItems value="#{ManagedProductosDesarrollo.unidadesMedidaSelectList}"  />
                            </h:selectOneMenu>
                            </h:panelGroup>
                            <h:outputText value="Peso Envase Primario" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:inputText styleClass="inputText" size="50" value="#{ManagedProductosDesarrollo.componentesProdEditar.pesoEnvasePrimario}"  id="pesoEnvasePrimario" onkeypress="valNum()" />
                            <h:outputText value="Nombre Comercial" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.componentesProdEditar.producto.codProducto}" id="forma" onchange="formarNombre();">
                                <f:selectItem itemValue="0" itemLabel="--Ninguno--"/>
                                <f:selectItems value="#{ManagedProductosDesarrollo.productosSelectList}"  />
                            </h:selectOneMenu>
                            <h:outputText value="Forma Farmaceútica" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.componentesProdEditar.forma.codForma}" id="prodComercial">
                                <f:selectItems value="#{ManagedProductosDesarrollo.formasFarmaceuticasSelectList}"  />
                            </h:selectOneMenu>
                            
                            <h:outputText value="Color Presentacion Primaria" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.componentesProdEditar.coloresPresentacion.codColor}" id="color" onchange="formarNombre();">
                                <f:selectItem itemValue="0" itemLabel="--Ninguno--"/>
                                <f:selectItems value="#{ManagedProductosDesarrollo.coloresPresPrimList}"  />
                            </h:selectOneMenu>
                            <h:outputText value="Sabor" styleClass="outputText2 negrita"  />
                            <h:outputText  value="::" styleClass="outputText2 negrita"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.componentesProdEditar.saboresProductos.codSabor}" id="sabor" onchange="formarNombre();">
                                <f:selectItem itemValue="0" itemLabel="--Ninguno--"/>
                                <f:selectItems value="#{ManagedProductosDesarrollo.saboresSelectList}"  />
                            </h:selectOneMenu>
                            <h:outputText value="Via Administracion" styleClass="outputText2 negrita"  />
                            <h:outputText  value="::" styleClass="outputText2 negrita"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.componentesProdEditar.viasAdministracionProducto.codViaAdministracionProducto}" id="viaAdministracion" >
                                <f:selectItems value="#{ManagedProductosDesarrollo.viasAdministracionSelectList}"  />
                            </h:selectOneMenu>
                            <h:outputText value="Area Fabricacion" styleClass="outputText2 negrita"  />
                            <h:outputText  value="::" styleClass="outputText2 negrita"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.componentesProdEditar.areasEmpresa.codAreaEmpresa}" id="areaEmpresa" >
                                <f:selectItems value="#{ManagedProductosDesarrollo.areasEmpresaSelectList}"  />
                            </h:selectOneMenu>
                            <h:outputText value="Producto Semiterminado" styleClass="outputText2 negrita"  />
                            <h:outputText  value="::" styleClass="outputText2 negrita"/>
                            <h:selectBooleanCheckbox value="#{ManagedProductosDesarrollo.componentesProdEditar.productoSemiterminado}"/>
                            <h:outputText value="Estado" styleClass="outputText2 negrita"  />
                            <h:outputText  value="::" styleClass="outputText2 negrita"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.componentesProdEditar.estadoCompProd.codEstadoCompProd}" id="codEstado" >
                                <f:selectItem itemLabel="Activo" itemValue="1"/>
                                <f:selectItem itemLabel="Discontinuado" itemValue="2"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                         
                        <br>

                        <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedProductosDesarrollo.guardarEdicionProductoDesarrollo_action}"
                        oncomplete="if(#{ManagedProductosDesarrollo.mensaje eq '1'}){alert('se guardo la edicion del producto');window.location.href='navegadorProductosDesarrollo.jsf?codE='+(new Date()).getTime().toString();}
                        else {alert('#{ManagedProductosDesarrollo.mensaje}')}"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorProductosDesarrollo.jsf?codAc='+(new Date()).getTime().toString();"/>
                </a4j:form>
                <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
            </center>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
        </body>
    </html>

</f:view>

