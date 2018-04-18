<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
   function nuevoAjax()
    {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }                    
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
     }
     
   
    function verificarCantidad()
    {
        var cantidadReg=0;
        var valoresTabla=document.getElementById('form1:dataProgramaProduccionEditar');
        var cantidadLote=parseFloat(document.getElementById('form1:cantidadLote').innerHTML);
        
            for(var j=1;j<valoresTabla.rows.length;j++)
            {
                cantidadReg+=parseFloat(valoresTabla.rows[j].cells[2].getElementsByTagName('input')[0].value);
            }
            if(cantidadReg<cantidadLote)
            {
               alert('No se puede registrar esta cantidad porque es menor a la cantidad del lote')
               return false;
            }
            if(cantidadReg>cantidadLote)
            {
                alert('No se puede registrar esta cantidad porque sobrepasa a la cantidad del lote')
                return false;

            }
        return true;
        
    }
    function repetirLote(celda)
    {
        var valoresTabla=document.getElementById('form1:dataProgramaProduccionEditar');
        for(var j=1;j<valoresTabla.rows.length;j++)
        {
            //inicio ale ultimo
            valoresTabla.rows[j].cells[3].getElementsByTagName('input')[0].value=celda.value;
            //final ale ultimo
        }
    }
    //inicio ale ultimo
    function verificar()
    {
        if(true) //verificarCantidad()
            {
        if(confirm('Esta seguro de guardar esta información?')==true)
        {


            var valoresTabla=document.getElementById('form1:dataProgramaProduccionEditar');
            
           for(var i=1;i<valoresTabla.rows.length;i++)
           {

               if(valoresTabla.rows[i].cells[4].getElementsByTagName('input')[0].value=='')
                  {
                      alert('No puede registrar el Nro de lote ');
                      return false;
                  }
               if(parseInt(valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT').length)!=0)
                   {
                       if(parseInt(valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT')[0].value)==0)
                       {
                           alert('Tiene que seleccionar el producto en la fila '+i);
                           return false;
                       }
                   }
               if(parseInt(valoresTabla.rows[i].cells[3].getElementsByTagName('SELECT')[0].value)==0)
                   {
                       alert('Tiene que seleccionar el tipo de programa produccion en la fila '+i);
                       return false;
                   }
                for(var j=1;j<valoresTabla.rows.length;j++)
                   {
                       if(i!=j)
                           {
                              /* if(((valoresTabla.rows[i].cells[0].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[i].cells[0].getElementsByTagName('SELECT')[0].value)==(valoresTabla.rows[j].cells[0].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[j].cells[0].getElementsByTagName('SELECT')[0].value))&&
                                  (valoresTabla.rows[i].cells[2].getElementsByTagName('SELECT')[0].value==valoresTabla.rows[j].cells[2].getElementsByTagName('SELECT')[0].value)&&
                                  (valoresTabla.rows[i].cells[3].getElementsByTagName('input')[0].value==valoresTabla.rows[j].cells[3].getElementsByTagName('input')[0].value))
                              */
                             if(((valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT')[0].value)==(valoresTabla.rows[j].cells[1].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[j].cells[1].getElementsByTagName('SELECT')[0].value))&&
                                  (valoresTabla.rows[i].cells[3].getElementsByTagName('SELECT')[0].value==valoresTabla.rows[j].cells[3].getElementsByTagName('SELECT')[0].value)&&
                                  (valoresTabla.rows[i].cells[4].getElementsByTagName('input')[0].value==valoresTabla.rows[j].cells[4].getElementsByTagName('input')[0].value))
                                  {
                                    alert('No puede registrar datos duplicados')
                                    return false;
                                  }


                           }
                   }

           }
           return true;
        }
        else
      {return false;}
      }
      else
          {return false;}
      return false;

    }
    //final ale ultimo
    
    //final ale edicion
    function guardarName(obj){
        //alert("hola");
        var nombreProducto=document.getElementById('form1:producto');
        //var fecha1=obj.parentNode.parentNode.innerHTML;//cells[3].getElementsByTagName('input')[0].value; //+' '+obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[1].value;
        var sel=obj.parentNode.parentNode.cells[3].getElementsByTagName('select')[0];//.getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[1].value;
        var input = obj.parentNode.parentNode.cells[8].getElementsByTagName('input')[0];
        //sel.options[sel.selectedIndex].text
        //alert(sel.options[sel.selectedIndex].text);
        input.value = sel.options[sel.selectedIndex].text;
        //alert(input.value);
        return true;
    }
    function guardarName1()
    {
                    var tabla=document.getElementById("form1:dataProgramaProduccionEditar");

                    var sel;
                    for(var i=1;i<tabla.rows.length;i++)
                        {   sel = tabla.rows[i].cells[3].getElementsByTagName('select')[0];
                            tabla.rows[i].cells[8].getElementsByTagName('input')[0].value=sel.options[sel.selectedIndex].text;

                        }
                 return true;
    }
    A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error "+message+" continue con su transaccion ");
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }


            function validarRegistro()
             {
                 
                 var tabla=document.getElementById("form1:dataProgramaProduccionEditar").getElementsByTagName("tbody")[0];
                 var cantidadSuma=0;
                 for(var i=0;i<tabla.rows.length;i++)
                 {
                     if((!validarMayorACero(tabla.rows[i].cells[2].getElementsByTagName("input")[0])) ||
                        (!validarSeleccionMayorACero(tabla.rows[i].cells[4].getElementsByTagName("select")[0])))     
                     {
                         return false;
                     }
                        cantidadSuma+=parseInt(tabla.rows[i].cells[2].getElementsByTagName("input")[0].value);
                 }
                 if(parseInt(document.getElementById("form1:cantidadLote").innerHTML)!=cantidadSuma)
                 {
                        if(confirm('La suma de las cantidades no es igual a la cantidad oficial del lote\nDesea registrar de todos modos?'))
                        {
                            return true;
                        }
                        return false;
                 }
                 return confirm('Esta seguro de guardar la edicion?');
             }
            function sumaCantidadTotalLote()
            {
                var tablaLotes=document.getElementById("form1:dataProgramaProduccionEditar").getElementsByTagName("tbody")[0];
                var cantidadTotal = 0.0;
                for(var i=0;i<tablaLotes.rows.length;i++)
                {
                    if(!isNaN(tablaLotes.rows[i].cells[2].getElementsByTagName("input")[0].value))
                    {
                        cantidadTotal += parseFloat(tablaLotes.rows[i].cells[2].getElementsByTagName("input")[0].value);
                    }
                }
                document.getElementById("form1:dataProgramaProduccionEditar:cantidadTotalLote").innerHTML = cantidadTotal;
            }
      </script>
        </head>
        
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProgramaProduccion.cargarProgramaProduccionEditar}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Edición de Programa de Producción" />
                    <h:panelGroup id="contenidoEditarLote">
                     <rich:panel headerClass="headerClassACliente" style="width:80%" >
                            <f:facet name="header">
                                <h:outputText value="Datos producto"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Producto"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText value="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.formulaMaestraVersion.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                                <h:outputText styleClass="outputTextBold" value="Cantidad Lote"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText id="cantidadLote" value="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.formulaMaestraVersion.cantidadLote}" styleClass="outputText2"/>
                                <h:outputText styleClass="outputTextBold" value="Lote"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:inputText value="#{ManagedProgramaProduccion.codLoteProducionEditar}" styleClass="inputText" disabled="true"
                                rendered="#{!ManagedProgramaProduccion.programaProduccionCabeceraEditar.loteConRegistros}"/>
                                <h:outputText value="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.codLoteProduccion}" styleClass="outputText2"
                                rendered="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.loteConRegistros}"/>
                                <h:outputText value="No se puede modificar el nro de lote" styleClass="outputText2" style="color:red;"
                                rendered="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.loteConRegistros}"/>

                            </h:panelGrid>
                        </rich:panel>
                        <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionEditarList}" var="data" id="dataProgramaProduccionEditar"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        style="margin-top:1em"
                                        binding="#{ManagedProgramaProduccion.programaProduccionEditarDataTable}"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                        headerClass="headerClassACliente" rowKeyVar="var" >
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Producto"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad Lote"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Programa Produccion"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Presentación"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Estado Programa"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Version de<br/>Producto" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Version de E.S."/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                           <rich:column>
                                <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{var != 0 && data.cantidadSalidasBaco eq 0 && data.estadoProgramaProduccion.codEstadoProgramaProd != '6'}"/>
                            </rich:column>
                            <rich:column>
                                <a4j:commandLink rendered="#{var != 0&& data.cantidadSalidasBaco eq 0}" action="#{ManagedProgramaProduccion.modificarProductoProgramaProduccionEditar_action}"
                                    oncomplete="Richfaces.showModalPanel('panelModificarProducto');" reRender="contenidoModificarProducto">
                                        <h:graphicImage url="../img/edit.jpg" style="vertical-align:middle"/>
                                        <h:outputText styleClass="outputText2" value="#{data.formulaMaestraVersion.componentesProd.nombreProdSemiterminado}"/>
                                    </a4j:commandLink>
                                    <h:outputText styleClass="outputText2" value="#{data.formulaMaestraVersion.componentesProd.nombreProdSemiterminado}" rendered="#{var eq 0||data.cantidadSalidasBaco>0}"/>
                                    <h:outputText styleClass="outputText2" style="color:red;" value="<br>#{data.cantidadSalidasBaco} salida(s) de Baco" rendered="#{data.cantidadSalidasBaco>0}" escape="false"/>
                            </rich:column>

                            <rich:column>
                                <h:inputText value="#{data.cantidadLote}" onblur="valorPorDefecto(this)" 
                                             onkeyup="sumaCantidadTotalLote()"
                                             styleClass="inputText"  disabled="#{data.estadoProgramaProduccion.codEstadoProgramaProd eq '6'}">
                                    <f:convertNumber pattern="#####"/>
                                </h:inputText>
                            </rich:column>

                             <rich:column>
                                    <h:selectOneMenu value="#{data.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" rendered="#{data.tiposProgramaProduccion.nombreTipoProgramaProd eq ''}" disabled="#{data.estadoProgramaProduccion.codEstadoProgramaProd eq '6'}">
                                        <f:selectItems value="#{ManagedProgramaProduccion.tiposProgramaProduccionSelectList}" />
                                        <a4j:support event="onchange"  action="#{ManagedProgramaProduccion.cargarPresentacionesProductoEditarSelect}" reRender="contenidoEditarLote"/>
                                    </h:selectOneMenu>
                                    <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}" rendered="#{data.tiposProgramaProduccion.nombreTipoProgramaProd != ''}"/>
                            </rich:column>
                            <rich:column>
                                <h:selectOneMenu value="#{data.presentacionesProducto.codPresentacion}" styleClass="inputText" 
                                                 rendered="#{!data.formulaMaestraVersion.componentesProd.productoSemiterminado}"
                                                 disabled="#{data.estadoProgramaProduccion.codEstadoProgramaProd eq '6'}">
                                    <f:selectItems value="#{data.presentacionesProductoList}" />
                                </h:selectOneMenu>
                                <h:outputText value="No aplica por ser un producto semiterminado" 
                                            rendered="#{data.formulaMaestraVersion.componentesProd.productoSemiterminado}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{data.formulaMaestraVersion.componentesProd.nroVersion}"/>
                            </rich:column>
                            <rich:column styleClass="tdCenter">
                                <h:outputText value="#{data.formulaMaestraEsVersion.componentesProdVersion.nroVersion}.#{data.formulaMaestraEsVersion.nroVersion}"/>
                                <br/>
                                <a4j:commandButton value="Cambiar version de E.S." styleClass="btn"
                                                   rendered="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.cantidadDesviaciones eq 0}"
                                                   oncomplete="Richfaces.showModalPanel('panelModificacionFormulaMaestraEsVersion')"
                                                   reRender="contenidoModificacionFormulaMaestraEsVersion"
                                                   action="#{ManagedProgramaProduccion.seleccionarCambiarFormulaMaestraEsVersion()}">
                                    <f:setPropertyActionListener value="#{data}" target="#{ManagedProgramaProduccion.programaProduccionCambiarFormulaEs}"/>
                                </a4j:commandButton>
                                <h:outputText rendered="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar.cantidadDesviaciones > 0}"
                                              value="<br/>El lote tiene registrada una desviacion planificada" style="color:red" escape="false"/>
                            </rich:column>
                            <f:facet name="footer">
                                <rich:columnGroup>
                                    <rich:column colspan="2">
                                        <h:outputText value="Cantidad Total" styleClass="outputTextBold"/>
                                    </rich:column>
                                    <rich:column styleClass="tdRight">
                                        <h:outputText value="#{ManagedProgramaProduccion.programaProduccionEditarListSumaCantidad}" 
                                                      styleClass="outputText2" id="cantidadTotalLote"/>
                                    </rich:column>
                                    <rich:column colspan="5">
                                        <h:outputText value=""/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                        </rich:dataTable>
                    </h:panelGroup>
                    
                    <center>
                        <a4j:commandLink action="#{ManagedProgramaProduccion.masProgramaProduccionEditar_action}" reRender="dataProgramaProduccionEditar" >
                            <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedProgramaProduccion.menosProgramaProduccionEditar_action}" reRender="dataProgramaProduccionEditar" >
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink>
                    </center>
                    <br>

                    <a4j:commandButton value="Guardar" styleClass="btn" onclick="if(!validarRegistro()){return false;}"  action="#{ManagedProgramaProduccion.guardarEdicionProgramaProduccion_action}"
                    oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'}){alert('Se guardo la edicion de lotes');window.location.href='navegadorProgramaProduccion.jsf?data='+(new Date()).getTime().toString();}else{alert('#{ManagedProgramaProduccion.mensaje}');}"/>
                   
                    <input type="button" class="btn" onclick="window.location.href='navegadorProgramaProduccion.jsf?cancele='+(new Date()).getTime().toString();" value="Cancelar" />
                    
               
               
                </div>
                
            </a4j:form>
            <rich:modalPanel id="panelModificacionFormulaMaestraEsVersion"
                             minHeight="340"  minWidth="700"
                             height="340" width="700" zindex="50"
                             headerClass="headerClassACliente"
                             resizeable="false">
                <f:facet name="header">
                    <h:outputText value="<center>Cambiar Version de Empaque Secundario</center>" escape="false" />
                </f:facet>
                <a4j:form id="formModificacionEsVersion">
                    <center>
                        <h:panelGroup id="contenidoModificacionFormulaMaestraEsVersion">
                            <div style='height:240px;overflow:auto;width:100%'>
                                <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraEsVersionList}"
                                             var="versionEs" id="versionEs"
                                             headerClass="headerClassACliente"
                                             onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                             onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                                        <f:facet name="header">
                                            <rich:columnGroup>
                                                <rich:column>
                                                    <h:outputText value="Seleccionar<br>Version E.S." escape="false"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Numero<br/>de version" escape="false"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Observación"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Fecha de creacion"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Fecha de Inicio<br/>Vigencia" escape="false"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Reporte"/>
                                                </rich:column>

                                            </rich:columnGroup>
                                        </f:facet>
                                        <rich:column>
                                            <a4j:commandButton value="Seleccionar" styleClass="btn"
                                                               action="#{ManagedProgramaProduccion.seleccionarFormulaMaestraEsVersion()}"
                                                               reRender="dataProgramaProduccionEditar"
                                                               oncomplete="Richfaces.hideModalPanel('panelModificacionFormulaMaestraEsVersion')">
                                                <f:setPropertyActionListener value="#{versionEs}" target="#{ManagedProgramaProduccion.programaProduccionCambiarFormulaEs.formulaMaestraEsVersion}"/>
                                            </a4j:commandButton>
                                        </rich:column>
                                        <rich:column styleClass="tdCenter">
                                            <h:outputText value="#{versionEs.componentesProdVersion.nroVersion}.#{versionEs.nroVersion}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{versionEs.observacion}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{versionEs.fechaCreacion}">
                                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{versionEs.fechaAprobacion}">
                                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column>
                                            <a4j:commandButton value="Reporte" styleClass="btn"
                                                               oncomplete="abrirVentana('../formullaMaestraVersiones/formulaMaestraDetalleES/empaqueSecundarioJasper/reporteComparacionVersionesEmpaqueSecundario.jsf?codFormulaMaestraEsVersion=#{versionEs.codFormulaMaestraEsVersion}')">
                                            </a4j:commandButton>
                                        </rich:column>
                                </rich:dataTable>
                            </div>
                        </h:panelGroup>
                    <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('panelModificacionFormulaMaestraEsVersion')" styleClass="btn"/>
                    </center>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelModificarProducto"
                             minHeight="340"  minWidth="700"
                             height="340" width="700" zindex="200"
                             headerClass="headerClassACliente"
                             resizeable="false">
                <f:facet name="header">
                    <h:outputText value="<center>Productos para división de lotes</center>" escape="false" />
                </f:facet>
                <a4j:form id="form3">
                    <center>
                    <h:panelGroup id="contenidoModificarProducto">
                        <table><tr><td>
                        <div style='height:240px;overflow:auto;width:100%'>
                        <rich:dataTable value="#{ManagedProgramaProduccion.productosDivisionLotesList}"
                                     var="data" id="detalle"
                                     headerClass="headerClassACliente"
                                     onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                     onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                              <f:facet name="header">
                                  <rich:columnGroup>
                                      <rich:column rowspan="2">
                                          <h:outputText value="Producto Semiterminado"/>
                                      </rich:column>
                                      <rich:column rowspan="2">
                                          <h:outputText value="Tipo Programa Producción"/>
                                      </rich:column>
                                      <rich:column rowspan="2">
                                          <h:outputText value="Cantidad Lote"/>
                                      </rich:column>
                                      <rich:column colspan="2">
                                          <h:outputText value="Nro version"/>
                                      </rich:column>
                                      <rich:column breakBefore="true">
                                          <h:outputText value="Producto"/>
                                      </rich:column>
                                      <rich:column>
                                          <h:outputText value="F.M."/>
                                      </rich:column>
                                  </rich:columnGroup>
                              </f:facet>

                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <a4j:commandLink action="#{ManagedProgramaProduccion.seleccionarProductoModificarProductoPrograma_action}"
                                      oncomplete="javascript:Richfaces.hideModalPanel('panelModificarProducto');"
                                      reRender="contenidoEditarLote">
                                          <f:param name="codCompProd" value="#{data.componentesProd.codCompprod}"/>
                                          <f:param name="codTipoProgramaProd" value="#{data.tiposProgramaProduccion.codTipoProgramaProd}"/>
                                          <f:param name="nombreCompProd" value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                          <f:param name="nombreTipoPrograma" value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                          <f:param name="codFormula" value="#{data.formulaMaestra.codFormulaMaestra}"/>
                                          <f:param name="codVersionFm" value="#{data.formulaMaestra.codVersionActiva}"/>
                                          <f:param name="codVersionCp" value="#{data.componentesProd.codVersionActiva}"/>
                                          <f:param name="codVersionFmEs" value="#{data.formulaMaestraEsVersion.codFormulaMaestraEsVersion}"/>
                                          <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                      </a4j:commandLink>
                                  </rich:column>
                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                  </rich:column>
                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <h:outputText value="#{data.formulaMaestra.cantidadLote}"/>
                                  </rich:column>
                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <h:outputText value="#{data.componentesProd.nroUltimaVersion}"/>
                                  </rich:column>
                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <h:outputText value="#{data.formulaMaestra.nroVersionFormulaActiva}"/>
                                  </rich:column>


                        </rich:dataTable>
                        </div>
                        </td></tr></table>
                    </h:panelGroup>
                    <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelModificarProducto');" styleClass="btn"/>
                    </center>
                </a4j:form>
            </rich:modalPanel>
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
        </body>
    </html>
    
    
</f:view>

