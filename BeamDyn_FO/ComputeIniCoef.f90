   SUBROUTINE ComputeIniCoef()

   INTEGER(IntKi):: allo_stat 

   ALLOCATE(K(4*member_total,4*member_total),STAT = allo_stat)
   IF(allo_stat/=0) GOTO 9999
   K(:,:) = 0.0D0

   ALLOCATE(RHS(4*member_total),STAT = allo_stat)
   IF(allo_stat/=0) GOTO 9999
   RHS(:) = 0.0D0
   
   DO i=1,3
       K(:,:) = 0.0D0
       RHS(:) = 0.0D0

       K(1,2) = 1.0D0
       RHS(1) = tang_vec(1,i)*(kp_coord(2,i)-kp_coord(1,i))
       DO j=1,member_total-1
           temp_id1 = (j-1)*4
           K(temp_id1+2,temp_id1+1) = 1.0D0
           K(temp_id1+3,temp_id1+1:temp_id1+4) = 1.0D0
           K(temp_id1+4,temp_id1+2) = 1.0D0
           K(temp_id1+4,temp_id1+3) = 2.0D0
           K(temp_id1+4,temp_id1+4) = 3.0D0
           temp = ((kp_coord(j+1,i)-kp_coord(j,i))/(kp_coord(j+2,i)-kp_coord(j+1,i)))
           K(temp_id1+4,temp_id1+6) = -temp
           K(temp_id1+5,temp_id1+3) = 2.0D0
           K(temp_id1+5,temp_id1+4) = 6.0D0
           K(temp_id1+5,temp_id1+7) = -2.0D0*temp*temp
           RHS(tempid1+2) = kp_coord(j,i)
           RHS(tempid1+3) = kp_coord(j+1,i)
       ENDDO
       temp_id1 = (member_total-1)*4
       K(temp_id1+2,temp_id1+1) = 1.0D0
       K(temp_id1+3,temp_id1+1:temp_id1+4) = 1.0D0
       K(temp_id1+4,temp_id1+2) = 1.0D0
       K(temp_id1+4,temp_id1+3) = 2.0D0
       K(temp_id1+4,temp_id1+4) = 3.0D0
       RHS(temp_id+2) = kp_coord(member_total,i)
       RHS(temp_id+3) = kp_coord(member_total+1,i)
       RHS(temp_id+4) = tang_vec(2,i)*(kp_coord(member_total+1,i)-kp_coord(member_total,i))

       CALL ludcmp(K,4*member_total,indx,d)
       CALL lubksb(K,4*member_total,indx,RHS,sol_temp)
       DO j=1,member_total
           DO k=1,4
               temp_id1 = (j-1)*4+k
               Coef(j,k,i) = sol_temp(temp_id1)
           ENDDO
       ENDDO
   ENDDO

   9999 IF(allo_stat/=0) THEN
            IF(ALLOCATED(K)) DEALLOCATE(K)
            IF(ALLOCATED(RHS)) DEALLOCATE(RHS)
        ENDIF

   END SUBROUTINE ComputeIniCoef
