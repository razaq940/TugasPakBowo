--No1
--Tampilkan fullname, jabatan, usia, dan jumlah anak dari masing-masing karyawan saat ini
select concat(b.first_name,' ',b.last_name) FullName, d.[name] Jabatan, DATEDIFF(hour,b.dob,GETDATE())/8766 Usia,(select count(*) from biodata bi left join family f on f.biodata_id = bi.id where f.status = 'Anak' )
from biodata b
join  employee e on e.biodata_id = b.id
join employee_position ep on ep.employee_id = e.id
join department d on d.id = ep.position_id
--No2
--Hitung berapa hari cuti yang sudah diambil masing-masing karyawan
select concat(b.first_name,' ',b.last_name) FullName , Sum(DATEDIFF(day, lr.start_date, lr.end_date)+1) [Cuti Yang Sudah DiAmbil]
from employee e
join biodata b on b.id = e.biodata_id
join leave_request lr on lr.employee_id = e.id
group by b.first_name, b.last_name
--No3
--Tampilkan fullname dan jabatan 3 karyawan paling tua
select top 3 concat(b.first_name,' ',b.last_name) FullName , d.[name] Jabatan
from biodata b
join employee e on e.biodata_id = b.id
join employee_position ep on ep.employee_id = e.id
join department d on d.id = ep.position_id
order by DATEDIFF(hour,b.dob,GETDATE())/8766 desc
--No4
--Tampilkan nama-nama pelamar yang tidak diterima sebagai karyawan
--No5
--Hitung berapa rata-rata gaji karyawan dengan level staff
select avg(e.salary) [Gaji rata rata karyawan level staff]
from biodata b
join employee e on e.biodata_id = b.id
join employee_position ep on ep.employee_id = e.id
join department d on d.id = ep.position_id
join position p on p.id = ep.position_id
where p.name = 'Staff'
--6
-- Tampilkan nama karyawan, jenis perjalanan dinas, tanggal perjalanan dinas, dan total pengeluarannya selama perjalanan dinas tersebut
select concat(b.first_name,' ',b.last_name) FullName, tt.[name], min(tr.[start_date]), sum(ts.item_cost)
from biodata b 
join employee e on e.biodata_id = b.id
join travel_request tr on tr.employee_id = e.id
join travel_settlement ts on ts.travel_request_id = tr.id
join travel_type tt on tt.id = tr.travel_type_id
group by b.first_name, b.last_name, tt.[name]
--7
--Tampilkan sisa cuti tahun 2020 yang dimiliki oleh karyawan
select concat(b.first_name,' ',b.last_name) FullName, el.regular_quota
from biodata b
join employee e on e.biodata_id = b.id
join employee_leave el on el.employee_id = e.id
where el.period = '2020'
--8
--Hitung berapa rata-rata gaji karyawan dengan level managerial (non staff)
select avg(e.salary) [Gaji rata rata karyawan level manager(non staff)]
from biodata b 
join employee e on e.biodata_id = b.id
join employee_position ep on ep.employee_id = e.id
join department d on d.id = ep.position_id
join position p on p.id = ep.position_id
where p.name != 'Staff'
--9
--Hitung ada berapa karyawan yang sudah menikah dan yang tidak menikah (tabel: menikah x orang, tidak menikah x orang)
select (select count(*)  
from biodata b
where b.marital_status = 1) Menikah, (select count(*)  
from biodata b
where b.marital_status = 0) [Tidak Menikah]
--no10
--Jika digabungkan antara cuti dan perjalanan dinas, berapa hari Raya tidak berada di kantor pada tahun 2020?
select e.id, concat(b.first_name,' ',b.last_name) FullName, ((select Sum(DATEDIFF(day, lr.start_date, lr.end_date)+1)
from employee e
join biodata b on b.id = e.biodata_id
join leave_request lr on lr.employee_id = e.id
group by b.first_name, b.last_name, e.id)) + ((select Sum(DATEDIFF(day, tr.start_date, tr.end_date)+1)
from employee e
join biodata b on b.id = e.biodata_id
join travel_request tr on tr.employee_id = e.id
group by b.first_name, b.last_name, e.id))
from employee e
join biodata b on b.id = e.biodata_id
