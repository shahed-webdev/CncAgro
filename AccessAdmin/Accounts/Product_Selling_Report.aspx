<%@ Page Title="Product Selling Report" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Product_Selling_Report.aspx.cs" Inherits="CncAgro.AccessAdmin.Accounts.Product_Selling_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Selling_Report.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Product Selling Report</h3>
    <div class="form-inline NoPrint">
        <div class="form-group">
            <asp:TextBox ID="From_TextBox" placeholder="From Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="datepicker form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:TextBox ID="TO_TextBox" placeholder="To Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="datepicker form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:TextBox ID="CustomerID_TextBox" CssClass="form-control" placeholder="Customer Id" runat="server"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" />
        </div>
    </div>

    <asp:FormView ID="Total_FormView" runat="server" DataSourceID="TotalSQL" Width="100%">
        <ItemTemplate>
            <div class="Amount_Summery alert alert-success">
                <label class="Date"></label>
                Total: <%# Eval("Total","{0:N}") %> Tk.
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="TotalSQL" runat="server" CancelSelectOnNullParameter="False" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(Shopping.ShoppingAmount) AS Total FROM Shopping INNER JOIN Member ON Shopping.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (CAST(Shopping.ShoppingDate AS DATE) BETWEEN ISNULL(@From_Date, N'1-1-1000') AND ISNULL(@To_Date, N'1-1-3000')) AND (Registration.UserName LIKE @UserName)">
        <SelectParameters>
            <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
            <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
            <asp:ControlParameter ControlID="CustomerID_TextBox" DefaultValue="%" Name="UserName" PropertyName="Text" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="table-responsive">
        <asp:GridView ID="Sellingeport_GridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="ShoppingID" DataSourceID="SellingeportSQL" AllowPaging="True" PageSize="50">
            <Columns>
                <asp:BoundField DataField="Shopping_SN" HeaderText="Receipt No" InsertVisible="False" ReadOnly="True" SortExpression="Shopping_SN" />
                <asp:BoundField DataField="UserName" HeaderText="User ID" SortExpression="UserName" />
                <asp:TemplateField HeaderText="Details">
                    <ItemTemplate>
                        <asp:DataList ID="RecordsDataList" runat="server" DataSourceID="Selling_RecordsSQL" Width="100%">
                            <ItemTemplate>
                                <asp:Label ID="Product_NameLabel" runat="server" Text='<%# Eval("Product_Name") %>' Font-Bold="True" ForeColor="#009933" />
                                <br />
                                Quantity:
                     <asp:Label ID="SellingQuantityLabel" runat="server" Text='<%# Eval("SellingQuantity") %>' />
                                <br />
                                Unit Price:
                     <asp:Label ID="SellingUnitPriceLabel" runat="server" Text='<%# Eval("SellingUnitPrice") %>' />
                                <br />
                                Unit Point:
                     <asp:Label ID="SellingUnitPointLabel" runat="server" Text='<%# Eval("SellingUnitPoint") %>' />
                            </ItemTemplate>
                        </asp:DataList>
                        <asp:HiddenField ID="ShoppingID_HF" runat="server" Value='<%# Eval("ShoppingID") %>' />
                        <asp:SqlDataSource ID="Selling_RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Selling_Records.SellingQuantity, Product_Selling_Records.SellingUnitPrice, Product_Selling_Records.SellingUnitPoint, Product_Point_Code.Product_Name, Product_Point_Code.Product_Code FROM Product_Selling_Records INNER JOIN Product_Point_Code ON Product_Selling_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Selling_Records.ShoppingID = @ShoppingID)">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="ShoppingID_HF" Name="ShoppingID" PropertyName="Value" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ShoppingAmount" HeaderText="Total Amount" SortExpression="ShoppingAmount" />
                <asp:BoundField DataField="ShoppingPoint" HeaderText="Total Point" SortExpression="ShoppingPoint" />
                <asp:BoundField DataField="ShoppingDate" HeaderText="Date" SortExpression="ShoppingDate" DataFormatString="{0:d MMM yyyy}" />
            </Columns>
            <EmptyDataTemplate>
                No Records
            </EmptyDataTemplate>
            <PagerStyle CssClass="pgr" />
        </asp:GridView>
        <asp:SqlDataSource ID="SellingeportSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping.ShoppingID, Shopping.ShoppingAmount, Shopping.ShoppingPoint, Shopping.ShoppingDate, Registration.UserName, Shopping.Shopping_SN FROM Shopping INNER JOIN Member ON Shopping.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (CAST(Shopping.ShoppingDate AS DATE) BETWEEN ISNULL(@From_Date, N'1-1-1000') AND ISNULL(@To_Date, N'1-1-3000')) AND (Registration.UserName LIKE @UserName)" CancelSelectOnNullParameter="False">
            <SelectParameters>
                <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
                <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
                <asp:ControlParameter ControlID="CustomerID_TextBox" DefaultValue="%" Name="UserName" PropertyName="Text" />
            </SelectParameters>
        </asp:SqlDataSource>

        <%if (Sellingeport_GridView.Rows.Count > 0)
            { %>
        <br />
        <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span> Print</button>
        <%} %>
    </div>

    <script type="text/javascript">
        $(function () {
            $('.datepicker').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });

            //get date in label
            var from = $("[id*=From_TextBox]").val();
            var To = $("[id*=TO_TextBox]").val();

            var tt;
            var Brases1 = "";
            var Brases2 = "";
            var A = "";
            var B = "";
            var TODate = "";

            if (To == "" || from == "" || To == "" && from == "") {
                tt = "";
                A = "";
                B = "";
            }
            else {
                tt = " To ";
                Brases1 = "(";
                Brases2 = ")";
            }

            if (To == "" && from == "") { Brases1 = ""; }

            if (To == from) {
                TODate = "";
                tt = "";
                var Brases1 = "";
                var Brases2 = "";
            }
            else { TODate = To; }

            if (from == "" && To != "") {
                B = " Before ";
            }

            if (To == "" && from != "") {
                A = " After ";
            }

            if (from != "" && To != "") {
                A = "";
                B = "";
            }

            $(".Date").text(Brases1 + B + A + from + tt + TODate + Brases2);
        });

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>
</asp:Content>
