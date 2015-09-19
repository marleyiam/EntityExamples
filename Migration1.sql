﻿declare
l_hist_tab_exists pls_integer;
l_current_migration nvarchar2(4000);
begin
select count(*) into l_hist_tab_exists from all_tables where owner = 'ANIMAL' and table_name = '__MigrationHistory';
if l_hist_tab_exists > 0 then
execute immediate '
select * from (
SELECT * 
FROM ( 
SELECT 
"Project1"."MigrationId" AS "MigrationId"
FROM ( SELECT 
	"Extent1"."MigrationId" AS "MigrationId"
	FROM "ANIMAL"."__MigrationHistory" "Extent1"
	WHERE ("Extent1"."ContextKey" = N''Animals.Database'')
)  "Project1"
ORDER BY "Project1"."MigrationId" DESC
)
WHERE (ROWNUM <= (1) )
)' into l_current_migration;
end if;

if l_current_migration is null then
l_current_migration := '0';
end if;

if l_current_migration < N'201509191542219_InitialCreate' then
execute immediate '
create table "ANIMAL"."Animals"
(
    "Name" nvarchar2(128) not null, 
    "Legs" number(10, 0) not null,
    constraint "PK_Animals" primary key ("Name")
)';

execute immediate '
create table "ANIMAL"."__MigrationHistory"
(
    "MigrationId" nvarchar2(150) not null, 
    "ContextKey" nvarchar2(300) not null, 
    "Model" blob not null, 
    "ProductVersion" nvarchar2(32) not null,
    constraint "PK___MigrationHistory" primary key ("MigrationId", "ContextKey")
)';

declare
model_blob blob;
begin
dbms_lob.createtemporary(model_blob, true);
dbms_lob.append(model_blob, to_blob(cast('1F8B0800000000000400CD56CB6EDB3010BC17E83F08BA47B49D4B1BC8095C3B2E8CC6761125B9D3D24A264A51024919F6B7F5D04FEA2F7469BD2CC98F34CDA117C3227787B3C3E192BF7FFE72EFB631B73620154BC4D0EE3B3DDB02E1270113D1D0CE7478F5C9BEBBFDF8C1BD0FE2ADF552C65D9B38CC146A68AFB54E6F0851FE1A62AA9C98F9325149A81D3F89090D1232E8F53E937E9F0042D8886559EE6326348B61FF819FE344F890EA8CF279120057C538CE787B546B41635029F561688F048B2957B635E28CE2F21EF0D0B6A81089A61AC9DD3C2BF0B44C44E4A53840F9D32E058C0B31090AD23775F86BF9F706863FA913DF54BF5D5586B5DDA3067A67E8EDEB2B4B3B8CC1A86FB06B0CE0D07799A420F5EE11C222D3FCDA16696692766A95D8C8320450462D71CB6D6B4EB70F2022BD46330C3ED9D6946D2128470A0D9F054387609296197E2E32CEE98A43354FCEAEFA00912A579D097D3DB880E0925AA8AE7C681D4D990059A04FA8A62B8A184D0E79B007BA2135F2A8B1732B39C5261CA5502D561B94E40E2D9D4C4E58D99DD33445810FAC5D8C585EEEEBF195F7F7968A730CE2AB23CEAAD8562BE944D2085AB3B834329D32A974259E350EE24ED82569CB659A0AB7CD5B0B5EC69BFF8D1CE7D84138D46C8A65C420F4BE22A8081C3F4145AAE7534EE5D113304E78168BD327E91C42EEE643847CA48BE09216FBB632A4234DEB3CB7953EE7D07648B57AE5D49623DDC21D973B70C72E79886DA1341B1618AB2C25F53938732A1031307123DF07A59C316758791D8A112C04A59F921F60EE9F81D36F75F6377459A254C0FFDF562B3654FA6B2A07DD6EFB0FAD5464F10AA451167C56DCE678491BD3E26CEF5D9B6CB761BCA6DB9E69B6B9833070319B8F1EB0A49C68D5A5DFD88CBB9676C9E1D3C39D8062510D611E22027C73BDD7A065CC4C8449A93F9676C8A80C696DCF1C340D8CF7A56621F5354E9B43B0BF675F28CF30E41E372D988965A6D34C8F948278C57787F5BAE4FCFAFB1BA7C9D95DA6E64BBD470948936109B0145F32C6838AF7F488854E4018B37C051CDF3F9BF09D8170D1AE425A24E29540857C13484104D8459E204E3982A9A5F0E8064E73BBAC61533177C2682469AC0A8C3ADFBC8489790ADFFE013C9922783C0B0000' as long raw)));
insert into "ANIMAL"."__MigrationHistory"("MigrationId", "ContextKey", "Model", "ProductVersion")
values ('201509191542219_InitialCreate', 'Animals.Database', model_blob, '6.0.0-20911');
end;
end if;
if l_current_migration < N'201509191558118_AddedSpecies' then
execute immediate '
alter table "ANIMAL"."Animals" add ("Species" nclob null)';

declare
model_blob blob;
begin
dbms_lob.createtemporary(model_blob, true);
dbms_lob.append(model_blob, to_blob(cast('1F8B0800000000000400CD56CD6EDB300CBE0FD83B18BE374AD24B57382DB2A4198235C950B7BD2B3693089325439283E4D976D823ED1546C5FFCE6FBB1E7609628AFCF8912245FEF9F5DBBBDF44DC5983D24C8A9EDB69B55D0744204326963D37318BAB1BF7FEEEF327EF218C36CE6BAE776DF5D052E89EBB3226BE2544072B88A86E452C5052CB85690532223494A4DB6E7F219D0E01847011CB71BCA7441816C1EE033F075204109B84F2890C81EB4C8E27FE0ED599D208744C03E8B97DC122CAB5EBF439A3E8DE07BE701D2A8434D420B9DB170DBE51522CFD1805943F6F6340BD051A4146FAB654BF947FBB6BF993D2F05DF1BB456418DB03E6C06C2DBD5D7C7968551DD4FA0EDB9A00453F948C4199ED132C324BFBEB3AA46E499AA68561CDCA12C0341A8557EE3A13BA7904B1342B2C86EE8DEB8CD806C25C92E5F04530AC1034322AC1CF69C2399D7328CEC949AF7E0C01037DC231FEBDC8F1693F8FB02C9C8C85B9EE9E61EA91F242F6AF094BD450264065E8436AE89C22469D43AAEC83A95D29F228B1D3926D65977D9042E1AC6C04927642DE31E448CB78131AC798CF4A0B6512C74FFB6770E5BFBD74A3148304FA4005176C0B4F462ABA84C629BA46A623A6B42992E70CC2684FED5C6A7337F50C379BA44C78AE6FFFD76C5A871AAE9AB31186118130BB88A02070B85333533FA09CAA839D36903C89C4F18E3D8550744D15A4105E8E937645152495EC2378A491856686C95E8A1BEF4FF3C64E557A53A5F05E547CA3B2BDACCACE4F8CBDB24B555C0753B366A12DB999A20187D6840A440CAD5E3F0840EBD680338CBC54450DB6006D9EE54FB0F3B2DBEA3426D13BA602D13AE4FFEF68106BAA821555DDFDE9F06F4FBF08B89C5741DEFAAC8B249A83B2B783B8D906838B892D7C3C6D7FE883BFFF785DF2F29F78F8D32A44C5E978D27FC49052A2C5C478E760D86F0B8F54D72D6F089A2D4B08BB7C0908EC4A5382E63A63B19079FE31B42AA35CA5713D133034B4FDA30C5BD0C0E0B16DA4DD887FA53C419507BCB4702C66898913D3D71AA239DF56E3F5C869FFBBE957E7ECCD62FBA53F2204A4C930049889AF09E361C17B74A0848E40D862F90628DFAD8AB8E220DC725B204DA5B810284BDF10621021BE44CF10C51CC1F44CF8740DC7B99DCF613D63DE90D1A5A291CE304A7BBBFD13BBFEDFFD05D87A8007300C0000' as long raw)));
insert into "ANIMAL"."__MigrationHistory"("MigrationId", "ContextKey", "Model", "ProductVersion")
values ('201509191558118_AddedSpecies', 'Animals.Database', model_blob, '6.0.0-20911');
end;
end if;
if l_current_migration < N'201509191611566_AddedEdible' then
declare
model_blob blob;
begin
dbms_lob.createtemporary(model_blob, true);
dbms_lob.append(model_blob, to_blob(cast('1F8B0800000000000400CD56CD6EDB300CBE0FD83B18BE374AD24B57382DB2A4198235C950B7BD2B3693089325439283E4D976D823ED1546C5FFCE6FBB1E7609628AFCF8912245FEF9F5DBBBDF44DC5983D24C8A9EDB69B55D0744204326963D37318BAB1BF7FEEEF327EF218C36CE6BAE776DF5D052E89EBB3226BE2544072B88A86E452C5052CB85690532223494A4DB6E7F219D0E01847011CB71BCA7441816C1EE033F075204109B84F2890C81EB4C8E27FE0ED599D208744C03E8B97DC122CAB5EBF439A3E8DE07BE701D2A8434D420B9DB170DBE51522CFD1805943F6F6340BD051A4146FAB654BF947FBB6BF993D2F05DF1BB456418DB03E6C06C2DBD5D7C7968551DD4FA0EDB9A00453F948C4199ED132C324BFBEB3AA46E499AA68561CDCA12C0341A8557EE3A13BA7904B1342B2C86EE8DEB8CD806C25C92E5F04530AC1034322AC1CF69C2399D7328CEC949AF7E0C01037DC231FEBDC8F1693F8FB02C9C8C85B9EE9E61EA91F242F6AF094BD450264065E8436AE89C22469D43AAEC83A95D29F228B1D3926D65977D9042E1AC6C04927642DE31E448CB78131AC798CF4A0B6512C74FFB6770E5BFBD74A3148304FA4005176C0B4F462ABA84C629BA46A623A6B42992E70CC2684FED5C6A7337F50C379BA44C78AE6FFFD76C5A871AAE9AB31186118130BB88A02070B85333533FA09CAA839D36903C89C4F18E3D8550744D15A4105E8E937645152495EC2378A491856686C95E8A1BEF4FF3C64E557A53A5F05E547CA3B2BDACCACE4F8CBDB24B555C0753B366A12DB999A20187D6840A440CAD5E3F0840EBD680338CBC54450DB6006D9EE54FB0F3B2DBEA3426D13BA602D13AE4FFEF68106BAA821555DDFDE9F06F4FBF08B89C5741DEFAAC8B249A83B2B783B8D906838B892D7C3C6D7FE883BFFF785DF2F29F78F8D32A44C5E978D27FC49052A2C5C478E760D86F0B8F54D72D6F089A2D4B08BB7C0908EC4A5382E63A63B19079FE31B42AA35CA5713D133034B4FDA30C5BD0C0E0B16DA4DD887FA53C419507BCB4702C66898913D3D71AA239DF56E3F5C869FFBBE957E7ECCD62FBA53F2204A4C930049889AF09E361C17B74A0848E40D862F90628DFAD8AB8E220DC725B204DA5B810284BDF10621021BE44CF10C51CC1F44CF8740DC7B99DCF613D63DE90D1A5A291CE304A7BBBFD13BBFEDFFD05D87A8007300C0000' as long raw)));
insert into "ANIMAL"."__MigrationHistory"("MigrationId", "ContextKey", "Model", "ProductVersion")
values ('201509191611566_AddedEdible', 'Animals.Database', model_blob, '6.0.0-20911');
end;
end if;
if l_current_migration < N'201509191613486_EdibleRenamed' then
declare
model_blob blob;
begin
dbms_lob.createtemporary(model_blob, true);
dbms_lob.append(model_blob, to_blob(cast('1F8B0800000000000400CD56CD6EDB300CBE0FD83B18BE374AD24B57382DB2A4198235C950B7BD2B3693089325439283E4D976D823ED1546C5FFCE6FBB1E7609628AFCF8912245FEF9F5DBBBDF44DC5983D24C8A9EDB69B55D0744204326963D37318BAB1BF7FEEEF327EF218C36CE6BAE776DF5D052E89EBB3226BE2544072B88A86E452C5052CB85690532223494A4DB6E7F219D0E01847011CB71BCA7441816C1EE033F075204109B84F2890C81EB4C8E27FE0ED599D208744C03E8B97DC122CAB5EBF439A3E8DE07BE701D2A8434D420B9DB170DBE51522CFD1805943F6F6340BD051A4146FAB654BF947FBB6BF993D2F05DF1BB456418DB03E6C06C2DBD5D7C7968551DD4FA0EDB9A00453F948C4199ED132C324BFBEB3AA46E499AA68561CDCA12C0341A8557EE3A13BA7904B1342B2C86EE8DEB8CD806C25C92E5F04530AC1034322AC1CF69C2399D7328CEC949AF7E0C01037DC231FEBDC8F1693F8FB02C9C8C85B9EE9E61EA91F242F6AF094BD450264065E8436AE89C22469D43AAEC83A95D29F228B1D3926D65977D9042E1AC6C04927642DE31E448CB78131AC798CF4A0B6512C74FFB6770E5BFBD74A3148304FA4005176C0B4F462ABA84C629BA46A623A6B42992E70CC2684FED5C6A7337F50C379BA44C78AE6FFFD76C5A871AAE9AB31186118130BB88A02070B85333533FA09CAA839D36903C89C4F18E3D8550744D15A4105E8E937645152495EC2378A491856686C95E8A1BEF4FF3C64E557A53A5F05E547CA3B2BDACCACE4F8CBDB24B555C0753B366A12DB999A20187D6840A440CAD5E3F0840EBD680338CBC54450DB6006D9EE54FB0F3B2DBEA3426D13BA602D13AE4FFEF68106BAA821555DDFDE9F06F4FBF08B89C5741DEFAAC8B249A83B2B783B8D906838B892D7C3C6D7FE883BFFF785DF2F29F78F8D32A44C5E978D27FC49052A2C5C478E760D86F0B8F54D72D6F089A2D4B08BB7C0908EC4A5382E63A63B19079FE31B42AA35CA5713D133034B4FDA30C5BD0C0E0B16DA4DD887FA53C419507BCB4702C66898913D3D71AA239DF56E3F5C869FFBBE957E7ECCD62FBA53F2204A4C930049889AF09E361C17B74A0848E40D862F90628DFAD8AB8E220DC725B204DA5B810284BDF10621021BE44CF10C51CC1F44CF8740DC7B99DCF613D63DE90D1A5A291CE304A7BBBFD13BBFEDFFD05D87A8007300C0000' as long raw)));
insert into "ANIMAL"."__MigrationHistory"("MigrationId", "ContextKey", "Model", "ProductVersion")
values ('201509191613486_EdibleRenamed', 'Animals.Database', model_blob, '6.0.0-20911');
end;
end if;
if l_current_migration < N'201509191646232_NotSureWhatChangedHere' then
execute immediate '
alter table "ANIMAL"."Animals" add ("Edible" number(1, 0) null)';

declare
model_blob blob;
begin
dbms_lob.createtemporary(model_blob, true);
dbms_lob.append(model_blob, to_blob(cast('1F8B0800000000000400CD57CD6EDA4010BE57EA3B58BE8705726923938840A85043A8E224F7C51E60D5F5AEB5BB46F06C3DF491FA0A9DC5FFE63FE9A117846767BEF9FD3CEB3FBF7E7B77EB883B2B509A49D1733BADB6EB800864C8C4A2E726667EF5C5BDBBFDFCC97B08A3B5F396EB5D5B3DB414BAE72E8D896F08D1C11222AA5B110B94D4726E5A818C080D25E9B6DB5F49A74300215CC4721CEF39118645B07DC0C7811401C426A17C2243E03A93E389BF45759E68043AA601F4DCBE6011E5DA75FA9C5174EF039FBB0E15421A6A30B89B570DBE51522CFC180594BF6C6240BD391A4116F44DA97E6EFCEDAE8D9F9486EFCADF2D32C3DC1EB0066663C3DBE697A756D541ADEFB0A90950F443C91894D93CC33CB3B4BFAE43EA96A4695A18D6AC6C005846A3B0E5AE33A1EB47100BB3C461E87E719D115B43984BB21ABE0A861382464625F8F894704E671C8A7372D4AB1F43C0401F718C7FCF727CDCCF232C0A276361AEBB1747FA103254CE31EEA5E440C509148F946DDD6D360EBAA14C80CA3C0CA9A1338A18F53852651F4C6D30309B123B1DFC5636327B43289C957422299F72DE9103C4F326348EB12B15226612C74F5938B8F22F274094629040EFE141116DE1C9484517D03845D718E988296D8AE2398330DA513B55DADC4DBDC24DAA9505CFF5EDFF9A4D6B1F6DAB351B611A1108B3CD088A00F6F33D33F503CAA9DACBD781E449240EF3FE1842C1BD2A48213C1F27E5561524959C8F9073AB8A91CB76513CD2A865B34F64A7518D7761B3EFC7F8D25429BC17BC69F0C3CB66F5F4F6DA19DE54C575B03C2B16DAC19D2A1A70684DA840C4D0EAF58300B46E0D38C3CC4B55D46073D0E645FE04BBBBBBAD4E632BBE634311AD43FEFFAE29B1A22A5852D5DDDD541F5B4322E0725605B974C588249A81B2DD41DCEC368597243BFC78DAFEE0F2D9877E36F8653B69F7FD7ACE723AB29BD21147C5A7F1A4FF8819A581164BED9DBB6B97731EA9DE2BBD2168B62821EC2D534060EF6E2568AE33167399370053AB4694AB34FA330143434B4E65D89C06068F2D4BB7779937CA13DB42EC593816D3C4C489E96B0DD18C6FAAF97AE4B8FFED82AEC7EC4D63FBA4FF450A1826C314602AEE13C6C322EED19E113A006187E51BA07C7B27C6BB1CC22D3605D29314670265E51B420C22C4D7DC0B443147303D153E5DC1E1D84ED7B05E316FC8E842D1486718A5BDFDCC21F63BE7F62F2775E8C6190D0000' as long raw)));
insert into "ANIMAL"."__MigrationHistory"("MigrationId", "ContextKey", "Model", "ProductVersion")
values ('201509191646232_NotSureWhatChangedHere', 'Animals.Database', model_blob, '6.0.0-20911');
end;
end if;
end;
