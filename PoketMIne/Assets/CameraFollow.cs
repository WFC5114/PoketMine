using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform target; // The target the camera should follow (usually the player)
    public float smoothSpeed = 0.125f; // How smoothly the camera catches up to its target
    public Vector3 offset; // The offset from the target position

    void LateUpdate()
    {
        Vector3 desiredPosition = target.position + offset;
        Vector3 smoothedPosition = Vector3.Lerp(transform.position, desiredPosition, smoothSpeed);
        transform.position = smoothedPosition;

       
        transform.LookAt(target);
    }
}

