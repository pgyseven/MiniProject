package com.miniproj.model;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString
public class BoardUpFilesVODTO {
	private int boardUpFileNo;
	private String newFileName;
	private String originalFileName;
	private String thumbFileName;
	private String ext;
	private int size;
	private int boardNo;
	private String base64Img;
	

}
