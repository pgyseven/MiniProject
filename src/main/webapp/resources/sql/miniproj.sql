
use pgy;
-- 회원 테이블 생성
CREATE TABLE `pgy`.`member` (
  `userId` VARCHAR(8) NOT NULL,
  `userPwd` VARCHAR(200) NOT NULL,
  `userName` VARCHAR(12) NULL,
  `mobile` VARCHAR(13) NULL,
  `email` VARCHAR(50) NULL,
  `registerDate` DATETIME NULL DEFAULT now(),
  `userImg` VARCHAR(45) NOT NULL DEFAULT 'avatar.png',
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `mobile_UNIQUE` (`mobile` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE);

-- 회원 테이블 수정(회원 포인트 점수 컬럼 부여)
ALTER TABLE `pgy`.`member` 
ADD COLUMN `userPoint` INT NULL DEFAULT 100 AFTER `userImg`;

-- DB 서버의 현재날짜와 현재 시간을 출력하는 쿼리문;
select now();

select md5('1234'); -- 암호화 기법 여러가지중 md5 쓴거임
select sha1('1234');

select sha1(md5('1234')); -- 실무에서는 이런식으로 두번 암호화 함

-- Member 테이블에 회원을 insert 하는 쿼리문
insert into member(userId, userPwd, userName, mobile, email) values(?, sha1(md5(?)), ?, ?, ?);

-- userId 로 해당 유저의 정보를 검색하는 쿼리문
select * from member where useId = ?;

-- member 테이블의 모든 회원 정보 검색하는 쿼리문
select * from member;

-- userId 가  ?인 회원 삭제 (회원 탈퇴)
delete from member where userId = ?;

-- dooly 라는 회원의 이메일을 수정하는 쿼리문
update member set email = 'dooly@dooly.com' where userId = 'dooly'; 
-- 데이터 선택 안되었다 에러드면 스키마 이름을 pgy.member 이렇게 use pgy; !

-- dooly 회원이 전화번호를 변결할 때 쿼리문 업데이트 쿼리문은 경우의 수가 많다 모바일일 수 도 있고 아닐수 도
update member set mobile = ? where userId = ?; 


-- 계층형 게시판 생성
CREATE TABLE `pgy`.`hboard` (
  `boardNo` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(20) NOT NULL,
  `content` VARCHAR(2000) NULL,
  `writer` VARCHAR(8) NULL,
  `postDate` DATETIME NULL DEFAULT now(),
  `readCount` INT NULL DEFAULT 0,
  `ref` INT NULL DEFAULT 0,
  `step` INT NULL DEFAULT 0,
  `refOrder` INT NULL DEFAULT 0,
  PRIMARY KEY (`boardNo`),
  INDEX `hboard_member_fk_idx` (`writer` ASC) VISIBLE,
  CONSTRAINT `hboard_member_fk`
    FOREIGN KEY (`writer`)
    REFERENCES `pgy`.`member` (`userId`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
COMMENT = '계층형 게시판';



-- 계층형 게시판에 모든 게시글을 가져오는 쿼리문
select * from hboard order by boardNo desc;

-- 계층형 게시판에 게시글을 등록하는 쿼리문
insert into hboard(title, content, writer)
values('아싸~~ 1등이다.', '내용 무....', 'dooly');

insert into hboard(title, content, writer)
values('금산에 살얼이', '죽고 죽어 일백번', 'kildong');

insert into hboard(title, content, writer)
values(?, ?, ?);

-- 유저에게 지급되는 포인트를 정의한 테이블 생성
CREATE TABLE `pgy`.`pointdef` (
  `pointWhy` VARCHAR(20) NOT NULL,
  `pointScore` INT NULL,
  PRIMARY KEY (`pointWhy`))
COMMENT = '유저에게 적립할 포인트에 대한 저의 테이블,\n어떤 사유로 몇 포인트를 지급하는지에 대해 정의';

-- pointdef 테이블의 기초 데이터
INSERT INTO `pgy`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('회원가입', '100');
INSERT INTO `pgy`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('로그인', '1');
INSERT INTO `pgy`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('글작성', '10');
INSERT INTO `pgy`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('댓글작성', '2');
INSERT INTO `pgy`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('게시글신고', '-10');


ALTER TABLE `pgy`.`pointdef` 
ADD COLUMN `pointdefNo` INT NOT NULL AUTO_INCREMENT FIRST,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`pointdefNo`);
;

--  유저의 포인트 적립 내역을 기록하는 pointlog 테이블 생성
CREATE TABLE `pgy`.`pointlog` (
  `pointLogNo` INT NOT NULL AUTO_INCREMENT,
  `pointWho` VARCHAR(8) NOT NULL,
  `pointWhen` DATETIME NULL DEFAULT now(),
  `pointWhy` VARCHAR(20) NOT NULL,
  `pointScore` INT NOT NULL,
  PRIMARY KEY (`pointLogNo`),
  CONSTRAINT `pointdef_member_fk`
    FOREIGN KEY (`pointWho`)
    REFERENCES `pgy`.`member` (`userId`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
COMMENT = '어떤 유저에게 어떤 사유로 몇 포인트가 언제 지급 되었는지를 기록하는 테이블 ';

-- 계층형 게시판 글 삭제 쿼리문
delete from hboard where boardNo=11;

-- 포인트 지급 log 저장하는 쿼리문 
insert into pointlog(pointWho, pointWhy, pointScore) values(?, ?, (select pointScore from pointdef where pointWhy = ?));

-- 유저에게 지급된 point를 update하는 쿼리문
update member set userpoint = userpoint + (select pointScore from pointdef where pointWhy = '글작성') where userId = ?;

-- 게시글의 첨부파일을 저장하는 테이블 생성
CREATE TABLE `pgy`.`boardimg` (
  `boardImgNo` INT NOT NULL AUTO_INCREMENT,
  `newFileName` VARCHAR(50) NOT NULL,
  `originalFileName` VARCHAR(50) NOT NULL,
  `ext` VARCHAR(4) NULL,
  `size` INT NULL,
  `boardNo` INT NOT NULL,
  `base64Img` TEXT NULL,
  INDEX `board_boardNo_fk_idx` (`boardNo` ASC) VISIBLE,
  PRIMARY KEY (`boardImgNo`),
  CONSTRAINT `board_boardNo_fk`
    FOREIGN KEY (`boardNo`)
    REFERENCES `pgy`.`hboard` (`boardNo`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
COMMENT = '게시판에 업로드 되는 업로드 파일을 기록하는 테이블';

-- 게시글 첨부 파일 테이블 수정
ALTER TABLE `pgy`.`boardimg` 
ADD COLUMN `thumbFileName` VARCHAR(60) NULL AFTER `originalFileName`;

-- 첨부 파일 테이블 이름 변경
ALTER TABLE `pgy`.`boardimg` 
RENAME TO  `pgy`.`boardupfiles` ;

 -- 컬럼명 변경
 ALTER TABLE `pgy`.`boardupfiles` 
CHANGE COLUMN `boardImgNo` `boardUpFileNo` INT NOT NULL AUTO_INCREMENT ;

-- 컬럼 크기 수정
ALTER TABLE `pgy`.`boardupfiles` 
CHANGE COLUMN `ext` `ext` VARCHAR(20) NULL DEFAULT NULL ;

-- 방금 insert 된 글의 글번호를 가져오는 쿼리문
select max(boardNo) from hboard;

-- 유저가 게시글을 저장할때 파일 업로드 하는 쿼리문
insert into boardupfiles(newFileName, originalFileName, thumbFileName, ext, size, boardNo, base64Img)
values(?, ?, ?, ?, ?, ?, ?);

-- 게시판 상세 페이지를 출력하는 쿼리문
select * from hboard where boardNo = 16;

select * from boardUpfiles where boardno=13; -- 이건 두번이라 속도에는 조금 느릴수 있다 2번 처리되니깐 뷰단으로 각각 가져가야해서 아우터 조인으로 하면 한번에

select * from member where userid = (select writer from hboard where boardNo = 16); -- 이렇게하면 맵 사용안하고 보드업파일스 맴버 조인 브이오를 채워서 사용 하는 버전에서는 이거 세개 사용

-- 게시글과 첨부 파일,  작성자 정보까지 함께 출력해보자(  조인 테이블 3개 3 - 1개의 조인조건이 나와야 한다.
select h.boardNo, h.title, h.content, h.writer, h.postDate, h.readCount
, f.*, m.userName, m.email 
from hboard h left outer join boardupfiles f
on h.boardNo = f.boardNo
inner join member m
on h.writer = m.userId
where h.boardNo = 41;
-- 참고로 여기서 select distinct h.boardNo, h.title, h.content, h.writer, h.postdate, h.readCount 이렇게 해도 중복은 제거 안된다.



-- 게시판 상세 페이지에서 그 게시글을 작성한 유저의 정보까지 출력 해 보자...


-- 부서명과 부서번호를 분리한 이유 데이터의 중복을 줄이기 위해서 equi(equal / =)Inner join사용 근데 이건 오라클만 가능 mysql은 ansi join
-- 서브쿼리로도 가능하다. 문제는 메인쿼리에서만 정보를 가져온다.
select *
from hboard inner join member
on hboard.writer = member.userid
where boardNo = 13;

select hboard.boardNo, board.title
from hboard inner join member
on hboard.writer = member.userid
where boardNo = 13;

-- 위도 기니깐 별명
select h.boardNo, h.title, m.userid, m.username
from hboard h inner join member m
on h.writer = m.userid -- 조인 조건(조인이 되는 테이블에서 의미가 같은 컬럼)
where h.boardNo = 13;

-- 게시글과 첨부파일을 함께 출력해보자
select *
from hboard h inner join boardupfiles f
on h.boardno = f.boardno;

select *
from hboard h left outer join boardupfiles f
on h.boardno = f.boardno; -- 이렇게 하면 현재 hboar 즉 왼쪽에 있는 board 정보 안나오니 left outer join을 쓴다 양쪽 다는 full outer
-- 이런 기능은 바지를 고르면 그 바지와 연관된걸 보여준다. 

-- 오라클에서 아래 두번째 명령어는 mysql도 가능 매니저가 king인 사원들의 이름과 직급 출력하세요
-- self join 하니의 테이블을 2개의 테이블인 것처럼 조인하여 출력하는 것, (테이블 별칭을 별도로 줘서 2개의 테이블인 것처럼 해야한다.)
SELECT ename, job FROM emp WHERE mgr=(SELECT empno FROM emp WHERE ename='KING');
select e.ename, e.mgr
from emp m inner join emp e on m.empNo = e.mgr
where m.ename = 'king';

-- 사원의 급여와 급여등급을 출력하세요 ... (NON EQUI JOIN)
select e.ename, e.sal, s.grade
from emp e, salgrade s
where e.sal > s.losal and e.sal < s.hisal; -- 오라클만 가능 ex 회원등급 얼마 팔았으면 골드 등급 사실 쓸데 많이 없다.

-- 컬럼의 중복 제거 포인트 부여 여러번 했을때 
select distinct 컬럼명 from pointlog;


-- 게시글의 조회수 증가 쿼리문
update hboard set readCount = readCount + 1
where boardNo = ?;

-- 게시판 조회수 증가를 위한 테이블 생성
CREATE TABLE `pgy`.`boardreadlog` (
  `boardReadLogNo` INT NOT NULL AUTO_INCREMENT,
  `readWho` VARCHAR(130) NOT NULL,
  `readWhen` DATETIME NULL DEFAULT now(),
  `boardNo` INT NOT NULL,
  PRIMARY KEY (`boardReadLogNo`))
COMMENT = '게시글을 조회한 내역 기록';

-- 1) readwho가 '0:0:0:0:0:0:0:1' 이고, boardNo가 ?번인 데이터가 있는지 조회
select readWhen from boardreadlog where readwho = '0:0:0:0:0:0:0:1' and boardno = 40;

-- 2 ) 1)번에서 나온 결과가 null 이면, insert
insert into boardreadlog(readwho, boardNo) values('0:0:0:0:0:0:0:1', 40);
insert into boardreadlog(readwho, boardNo) values(?, ?);
-- 3) 1)번에서 나온 결과가 null이 아니면... 현재날짜 시간과 이전에 읽은 날짜 시간의 날짜 차이를 구해야 한다.
-- 1)번 + 3)번의 내용 subquery와 함수를 이용하면 아래의 한 문장으로 해결할 수 있다.
select ifnull(datediff(now(), (select readWhen from boardreadlog where readWho = '0:0:0:0:0:0:0:1' and boardNo = 40)), -1) as datediff;

select ifnull(datediff(now(), (select readWhen from boardreadlog where readWho = ? and boardno = ?)), -1) as datediff;


-- 4) 3번에서 나온 결과가 1이상이면 조회한 후 조회한 readWhen 을 현재 시간으로 update 시켜야 한다.
update boardreadlog set readWhern = now() where readWho = ? and boardNo = ?;