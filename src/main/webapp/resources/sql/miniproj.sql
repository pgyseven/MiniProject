
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


