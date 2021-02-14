<%@ Page Title="Customer Details" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Member_Details.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.Member_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../CSS/Member_details.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="mb-3">
        <a class="Bak" href="Member_List.aspx"><< Back To Customer List</a>
    </div>

    <ul class="nav nav-tabs" role="tablist">
        <li class="nav-item"><a class="nav-link active" data-toggle="tab" role="tab" aria-selected="true" href="#Dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" data-toggle="tab" role="tab" aria-selected="true" href="#Customers_Info">Update Info</a></li>
    </ul>

    <div class="tab-content">
        <div id="Dashboard" role="tabpanel" class="tab-pane fade show active">
            <asp:FormView ID="MemberFormView" runat="server" DataKeyNames="RegistrationID" DataSourceID="MemberSQL" Width="100%">
                <ItemTemplate>
                    <div class="Info">
                        <div class="infowrap">
                            <img src="/Handler/UserPhoto.ashx?id=<%#Eval("RegistrationID") %>" class="img-thumbnail img-responsive" alt=""/>
                        </div>
                        <div class="infowrap">
                            <ul>
                                <li>
                                    <i class="glyphicon glyphicon-user rest-userico"></i>
                                    <b>Name:</b>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>' />
                                </li>
                                <li>
                                    <span class="glyphicon glyphicon-earphone"></span>
                                    <b>Mobile:</b>
                                    <asp:Label ID="PhoneLabel1" runat="server" Text='<%# Bind("Phone") %>' />
                                </li>
                                <li>
                                    <i class="glyphicon glyphicon-user rest-userico"></i>
                                    <b>Referral ID:</b>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Refarel_UserName") %>' />
                                </li>
                                <li>
                                    <i class="glyphicon glyphicon-calendar"></i>
                                    <b>Signup Date:</b>
                                    <asp:Label ID="SignUpDateLabel" runat="server" Text='<%# Bind("SignUpDate","{0:d MMMM yyyy}") %>' />
                                </li>
                            </ul>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                </ItemTemplate>
            </asp:FormView>
            <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.Email, Member.MemberID, Member.SignUpDate, Registration.RegistrationID, Refarel_Registration.UserName AS Refarel_UserName, Registration.Phone FROM Registration AS Refarel_Registration INNER JOIN Member AS Refarel_Member ON Refarel_Registration.RegistrationID = Refarel_Member.MemberRegistrationID RIGHT OUTER JOIN Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID ON Refarel_Member.MemberID = Member.Referral_MemberID WHERE (Member.MemberID = @MemberID)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="MemberID" QueryStringField="member" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:FormView ID="BonusFormView" runat="server" DataSourceID="BonusSQL" Width="100%">
                <ItemTemplate>
                    <h3><strong style="color: #4285F4">Balance: ৳<%#Eval("Available_Balance","{0:N}") %></strong></h3>
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="Comission">
                                <h5>Referral Commission</h5>
                                <%#Eval("Referral_Income","{0:N}") %>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="Comission">
                                <h5>Generation Commission</h5>
                                <%#Eval("Generation_Income","{0:N}") %>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="Comission">
                                <h5>Retail Commission</h5>
                                <%#Eval("Instant_Cash_Back_Income","{0:N}") %>
                            </div>
                        </div>
                    </div>

                    <h3>Send & received balance</h3>
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="white-box">
                                <h2 class="box-title">
                                    <i class="fa fa-arrow-circle-up" aria-hidden="true"></i>
                                    Withdraw Balance
                                </h2>
                                <ul class="list-inline two-part">
                                    <li>
                                        <i class="fa fa-money b-color" aria-hidden="true"></i>
                                    </li>
                                    <li class="text-right b-color">
                                        <span><%#Eval("Withdraw_Balance","{0:N}") %></span>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-sm-4">
                            <div class="white-box">
                                <h2 class="box-title">
                                    <i class="fa fa-paper-plane" aria-hidden="true"></i>
                                    Send Balance
                                </h2>
                                <ul class="list-inline two-part">
                                    <li>
                                        <i class="fa fa-money b-color" aria-hidden="true"></i>
                                    </li>
                                    <li class="text-right b-color">
                                        <span><%#Eval("Send_Balance","{0:N}") %></span>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-sm-4">
                            <div class="white-box">
                                <h2 class="box-title">
                                    <i class="fa fa-arrow-circle-down" aria-hidden="true"></i>
                                    Received Balance
                                </h2>
                                <ul class="list-inline two-part">
                                    <li>
                                        <i class="fa fa-money b-color" aria-hidden="true"></i>
                                    </li>
                                    <li class="text-right b-color">
                                        <span><%#Eval("Received__Balance","{0:N}") %></span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:FormView>
            <asp:SqlDataSource ID="BonusSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Referral_Income, Generation_Income, Instant_Cash_Back_Income, Available_Balance, SignUpDate, Total_Amount, Withdraw_Balance, Send_Balance, Received__Balance FROM Member WHERE (MemberID = @MemberID)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="MemberID" QueryStringField="member" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>

        <div id="Customers_Info" class="tab-pane">
            <asp:FormView ID="MemberDetailsFormView" DefaultMode="Edit" runat="server" DataKeyNames="MemberID,RegistrationID,Default_MemberStatus" DataSourceID="MemberDetailsSQL" Width="100%" OnItemUpdated="MemberDetailsFormView_ItemUpdated">
                <EditItemTemplate>
                    <div class="col-md-6">
                        <input id="QueryMemberID" value='<%# Eval("MemberID") %>' type="hidden" />
                        <h4 class="my-3"><%#Eval("Name") %></h4>

                        <div class="alert alert-success text-center">
                            <label>User ID</label>
                            <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />.

                                    <label>Referral User ID</label>
                            <asp:Label ID="Referral_Label" runat="server" Text='<%# Bind("R_UserName") %>' />.
                        </div>

                        <img alt="" src="/Handler/UserPhoto.ashx?id=<%#Eval("RegistrationID") %>" class="img-responsive img-circle Photo" />


                        <div class="form-group">
                            <label>Name</label>
                            <asp:TextBox ID="NameTextBox" CssClass="form-control" runat="server" Text='<%# Bind("Name") %>' />
                        </div>

                        <div class="form-group">
                            <label>Father's Name</label>
                            <asp:TextBox ID="FatherNameLabel" CssClass="form-control" runat="server" Text='<%# Bind("FatherName") %>' />
                        </div>

                        <div class="form-group">
                            <label>Mother's Name</label>
                            <asp:TextBox ID="MotherNameLabel" CssClass="form-control" runat="server" Text='<%# Bind("MotherName") %>' />
                        </div>

                        <div class="form-group">
                            <asp:RadioButtonList ID="GenderRadioButtonList" runat="server" RepeatDirection="Horizontal" SelectedValue='<%# Bind("Gender") %>'>
                                <asp:ListItem>Male</asp:ListItem>
                                <asp:ListItem>Female</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                        <div class="form-group">
                            <label>National ID</label>
                            <asp:TextBox ID="NationalIDLabel" CssClass="form-control" runat="server" Text='<%# Bind("NationalID") %>' />
                        </div>

                        <div class="form-group">
                            <label>Present Address</label>
                            <asp:TextBox ID="Present_AddressLabel" CssClass="form-control" runat="server" Text='<%# Bind("Present_Address") %>' />
                        </div>
                        <div class="form-group">
                            <label>Permanent Address</label>
                            <asp:TextBox ID="Permanent_AddressLabel" CssClass="form-control" runat="server" Text='<%# Bind("Permanent_Address") %>' />
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <asp:TextBox ID="PhoneLabel" CssClass="form-control" runat="server" Text='<%# Bind("Phone") %>' />
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <asp:TextBox ID="EmailLabel" CssClass="form-control" runat="server" Text='<%# Bind("Email") %>' />
                        </div>
                        <div class="form-group">
                            <label>SignUp Date</label>
                            <asp:Label ID="SignUpDateLabel" runat="server" Text='<%# Bind("SignUpDate","{0:d MMM yyyy}") %>' />
                        </div>
                        <div class="form-group">
                            <label>Date of Birth</label>
                            <asp:TextBox ID="DateofBirthLabel" CssClass="form-control datepicker" runat="server" Text='<%# Bind("DateofBirth") %>' />
                        </div>

                        <div class="form-group">
                            <label>Blood Group</label>
                            <asp:DropDownList ID="BloodGroupDropDownList" runat="server" CssClass="form-control" SelectedValue='<%# Bind("BloodGroup") %>'>
                                <asp:ListItem Value=" ">[ SELECT ]</asp:ListItem>
                                <asp:ListItem>A+</asp:ListItem>
                                <asp:ListItem>A-</asp:ListItem>
                                <asp:ListItem>B+</asp:ListItem>
                                <asp:ListItem>B-</asp:ListItem>
                                <asp:ListItem>AB+</asp:ListItem>
                                <asp:ListItem>AB-</asp:ListItem>
                                <asp:ListItem>O+</asp:ListItem>
                                <asp:ListItem>O-</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label>Nominee Name</label>
                            <asp:TextBox ID="TextBox1" CssClass="form-control" runat="server" Text='<%# Bind("Nominee_Name") %>' />
                        </div>
                        <div class="form-group">
                            <label>Nominee Relationship</label>
                            <asp:TextBox ID="TextBox2" CssClass="form-control" runat="server" Text='<%# Bind("Nominee_Relationship") %>' />
                        </div>
                        <div class="form-group">
                            <label>Nominee Date Of Birth</label>
                            <asp:TextBox ID="TextBox7" CssClass="form-control datepicker" runat="server" Text='<%# Bind("Nominee_DOB") %>' />
                        </div>
                        <img alt="" src="/Handler/NomineeImage.ashx?id=<%#Eval("MemberID") %>" class="img-responsive img-circle Photo" />

                        <div class="form-group">
                            <label>Bank</label>
                            <asp:TextBox ID="TextBox3" CssClass="form-control" runat="server" Text='<%# Bind("Bank") %>' />
                        </div>
                        <div class="form-group">
                            <label>Branch</label>
                            <asp:TextBox ID="TextBox4" CssClass="form-control" runat="server" Text='<%# Bind("Branch") %>' />
                        </div>
                        <div class="form-group">
                            <label>Account Name</label>
                            <asp:TextBox ID="TextBox5" CssClass="form-control" runat="server" Text='<%# Bind("AccountName") %>' />
                        </div>
                        <div class="form-group">
                            <label>Account No.</label>
                            <asp:TextBox ID="TextBox6" CssClass="form-control" runat="server" Text='<%# Bind("AccountNo") %>' />
                        </div>
                        <div class="form-group">
                            <label>Upload/Change Doc.</label>
                            <asp:FileUpload ID="ImageFileUpload" runat="server" />
                        </div>

                        <div class="form-group">
                            <img alt="" src="/Handler/DocumentImage.ashx?id=<%#Eval("MemberID") %>" class="img-responsive img-thumbnail Doc" />
                        </div>

                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" CssClass="btn btn-primary" Text="Update" />
                    </div>
                </EditItemTemplate>
            </asp:FormView>
            <asp:SqlDataSource ID="MemberDetailsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.FatherName, Registration.Gender, Registration.NationalID, Registration.Present_Address, Registration.Permanent_Address, Registration.Phone, Registration.Email, Registration.MotherName, Registration.UserName, Member.Is_Identified, Member.SignUpDate, Member.MemberID, Registration.RegistrationID, Registration.DateofBirth, Registration.BloodGroup, R_Registration.UserName AS R_UserName, Member.Default_MemberStatus, Member.MemberRegistrationID, Member.Nominee_Name, Member.Nominee_Relationship, Member.Nominee_DOB, Member.Bank, Member.Branch, Member.AccountName, Member.AccountNo FROM Registration AS R_Registration INNER JOIN Member AS R_Member ON R_Registration.RegistrationID = R_Member.MemberRegistrationID RIGHT OUTER JOIN Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID ON R_Member.MemberID = Member.Referral_MemberID WHERE (Registration.Category = N'Member') AND (Member.MemberID = @MemberID)"
                UpdateCommand="UPDATE  Registration SET  Name = @Name, FatherName = @FatherName, MotherName = @MotherName, DateofBirth = @DateofBirth, BloodGroup = @BloodGroup, Gender = @Gender, NationalID = @NationalID,Present_Address = @Present_Address, Permanent_Address = @Permanent_Address, Phone = @Phone, Email = @Email FROM  Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID
WHERE   (Member.MemberID = @MemberID)


UPDATE Member SET Nominee_Name = @Nominee_Name, Nominee_Relationship = @Nominee_Relationship,Nominee_DOB = @Nominee_DOB, Bank = @Bank, Branch = @Branch, AccountName = @AccountName, AccountNo = @AccountNo WHERE(MemberID = @MemberID)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="MemberID" QueryStringField="member" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" />
                    <asp:Parameter Name="FatherName" />
                    <asp:Parameter Name="MotherName" />
                    <asp:Parameter Name="DateofBirth" />
                    <asp:Parameter Name="BloodGroup" />
                    <asp:Parameter Name="Gender" />
                    <asp:Parameter Name="NationalID" />
                    <asp:Parameter Name="Present_Address" />
                    <asp:Parameter Name="Permanent_Address" />
                    <asp:Parameter Name="Phone" />
                    <asp:Parameter Name="Email" />
                    <asp:Parameter Name="MemberID" />
                    <asp:Parameter Name="Nominee_Name" />
                    <asp:Parameter Name="Nominee_Relationship" />
                    <asp:Parameter Name="Bank" />
                    <asp:Parameter Name="Branch" />
                    <asp:Parameter Name="AccountName" />
                    <asp:Parameter Name="AccountNo" />
                    <asp:Parameter Name="Nominee_DOB" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>
    </div>


    <asp:UpdateProgress ID="UpdateProgress" runat="server">
        <ProgressTemplate>
            <div id="progress_BG"></div>
            <div id="progress">
                <img src="/CSS/Image/loading.gif" alt="Loading..." />
                <br />
                <b>Loading...</b>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <script>
        $(function () {
            $('.datepicker').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });

            $('#Current_Plc_ID').text($('[id*=Placement_Label]').text());

            //Autocomplete... User ID
            $('[id*=PositionMemberUserNameTextBox]').typeahead({
                minLength: 4,
                source: function (request, result) {
                    $.ajax({
                        url: "Member_Details.aspx/Get_UserInfo_ID",
                        data: JSON.stringify({ 'prefix': request }),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (response) {
                            label = [];
                            map = {};
                            $.map(JSON.parse(response.d), function (item) {
                                label.push(item.Username);
                                map[item.Username] = item;
                            });
                            result(label);
                        }
                    });
                },
                updater: function (item) {
                    $("#P_info").css("display", "block");
                    $("#P_Name_Label").text(map[item].Name);
                    $("#P_Phone_Label").text(map[item].Phone);
                    $("[id*=PositionTypeDropDownList]")[0].selectedIndex = 0;
                    return item;
                }
            });

            $("[id*=PositionTypeDropDownList]").on('change', function () {
                var PositionType = $(this).find('option:selected').text();
                var memberID = $("#QueryMemberID").val();
                var Pmuser = $('[id*=PositionMemberUserNameTextBox]').val();

                if ($("[id*=PositionTypeDropDownList] option:selected").val() != "0") {
                    $.ajax({
                        type: "POST",
                        url: "Member_Details.aspx/Check_PositionMemberUserName",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ 'MemberID': memberID, 'PositionMemberUserName': Pmuser, 'PositionType': PositionType }),
                        dataType: "json",
                        success: function (response) {
                            $("#Is_P_Position").text(response.d);

                            if (response.d != "") {
                                $("[id*=ChangeIDButton]").prop("disabled", true);
                            }
                            else {

                                $("[id*=ChangeIDButton]").prop("disabled", false);
                            }
                        }
                    });
                }
            });
        });
    </script>
</asp:Content>
